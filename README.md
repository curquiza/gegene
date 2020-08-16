# Gégène <!-- omit in TOC -->

Gégène is a **Meili's internal tool** to generate the `.code-samples` file (available in the MeiliSearch SDKs) based on the already existing tests suite of the SDK.<br>
**This way, we can ensure the code snippets are tested and up-to-date.**

#### More context <!-- omit in TOC -->

Each MeiliSearch SDK provides a `.code-samples.meilisearch.yaml` file containing code samples about the SDK usage. These specific files are used by the MeiliSearch documentation to generate code snippets in the [API References](https://docs.meilisearch.com/references/). See, [this example](https://docs.meilisearch.com/references/indexes.html#example).<br>
These code samples are currently manually written and can contain errors (typo, obsolete functions...).

_More about the [code-samples plugin](https://github.com/meilisearch/documentation/tree/master/.vuepress/code-samples) in the MeiliSearch documentation._

_More about [Gégène](https://shadoks.fandom.com/fr/wiki/G%C3%A9g%C3%A8ne)._

## Table of Contents ! <!-- omit in TOC -->

- [How to Run](#how-to-run)
- [The Config File](#the-config-file)
- [In the Test Files](#in-the-test-files)
- [Contributing](#contributing)

## How to Run

```bash
$ bundle exec ruby src/main.rb <config-file-path> > '.code-samples.meilisearch.yaml'
```

### Give a try! <!-- omit in TOC -->

This repository provides config files and their according tests. For example, run:

```bash
$ bundle exec ruby src/main.rb './examples/config/php-config.yml' > '.code-samples.meilisearch.yaml'
$ cat .code-samples.meilisearch.yaml
```

## The Config File

| Key                      | Description                                                                                    | Type            |
|--------------------------|------------------------------------------------------------------------------------------------|-----------------|
| `template_url`           | The URL to fetch the empty template of code-samples.                                           | String          |
| `test_files`             | The test files containing the code samples.                                                    | List of strings |
| `replacers`              | _Optional_<br> Globally replaces sub-string by another string.                                 | Integer         |
| `nb_lines`               | _Optional, default: `1`_<br> The number of lines fetch after the `GEGENE` comment.             | List of dict    |
| `display_final_variable` | _Optional, default: `false`_<br> If `false`, removes the variable assignment in the last line. | Boolean         |


All the optional keys are **globally** applied but are also individually settable for a single test.

### Example <!-- omit in TOC -->

```yml
template_url: 'https://raw.githubusercontent.com/meilisearch/documentation/master/.vuepress/public/sample-template.yaml'
test_files:
  - './examples/tests-suite/php-tests/**/*.php'
replacers:
  - search: '$this->index->'
    replace: "$client->getIndex('movies')->"
  - search: '$index->'
    replace: "$client->getIndex('movies')->"
  - search: '$this->client->'
    replace: '$client->'
```

## In the Test Files

To make Gégène able to fetch the right code-sample according to the id [in the template](https://docs.meilisearch.com/sample-template.yaml), just add this comment line:

```php
public function testVersion(): void
{
    // GEGENE get_version_1
    $response = $this->client->version();

    $this->assertArrayHasKey('commitSha', $response);
    $this->assertArrayHasKey('buildDate', $response);
    $this->assertArrayHasKey('pkgVersion', $response);
}
```

⚠️ If your file is a `.rb` or `.py` file, your comment should obviously begin with `#` instead of `//`.

This will display the following line in the template:

```yml
get_version_1: |-
  $this->client->version();
```

The `$response` is removed because `display_final_variable` is globally set to `false` by default.

By using the config file given in example that contains global `replacers`, we will finally get:

```yml
get_version_1: |-
  $client->version();
```

### More Examples <!-- omit in TOC -->

⚠️ An individual option is applied **before** the global one.

#### Individual Replacers <!-- omit in TOC -->

```php
// GEGENE create_an_index_1 => replacer: 'index' 'movies' ; replacer: ObjectId movie_id
$index = $client->createIndex('index', ['primaryKey' => 'ObjectId']);
```

```yml
create_an_index_1: |-
  $client->createIndex('movies', ['primaryKey' => 'movie_id']);
```

#### Display the Final Variable Assignment <!-- omit in TOC -->

```php
// GEGENE list_all_indexes_1 => display_final_variable: true
$indexes = $client->getAllIndexes();
```

```yml
list_all_indexes_1: |-
  $indexes = $client->getAllIndexes();
```

#### Handle Multi-lines <!-- omit in TOC -->

```php
// GEGENE add_or_replace_documents_1 => nb_lines: 5
$new_documents = [
    ['id' => 123, 'title' => 'Pride and Prejudice'],
    ['id' => 456, 'title' => 'Le Petit Prince']
];
$client->getIndex('books')->addDocuments($new_documents);
```

```yml
add_or_replace_documents_1: |-
  $new_documents = [
      ['id' => 123, 'title' => 'Pride and Prejudice'],
      ['id' => 456, 'title' => 'Le Petit Prince']
  ];
  $client->getIndex('books')->addDocuments($new_documents);
```

Gégène keeps the same indentation as in you test file.

#### Handle Markdown Code Samples <!-- omit in TOC -->

Two points:
- All the commented lines after the `GEGENE` comment are considered as text, so the comment chars will be removed.
- If a code-sample id is use twice (here, `getting_started_search_md`), the lines are appended instead of being overwritten.

```php
// GEGENE getting_started_search_md => nb_lines: 2 ; replacer: $movies_index $index
// ```php
$search = $movies_index->search('botman');

// GEGENE getting_started_search_md => nb_lines: 3
// ```
//
// [About this package](https://github.com/meilisearch/meilisearch-php/)
```

💡 We split them into two blocks here to remove the final variable assignment (`$search`) thanks to the default behavior.<br>
`display_final_variable` is indeed set to `false` by default

```yml
getting_started_search_md: |-
  ```php
  $movies_index->search('botman');
  \```

  [About this package](https://github.com/meilisearch/meilisearch-php/)
```

*(The `\` above is only to avoid the README highlight to be messed up, the [real lines](https://github.com/curquiza/gegene/blob/370c62a807a73d59da525311b3b062235cdf70fc/tests/expected-output-php.yml#L137-L142) don't contain it.)*

## Contributing

Install dependencies:

```bash
$ bundle install --with development
```

Run tests and the linter:

```bash
# Run the tests
$ tests/run_tests.sh
# Check the linter errors
$ bundle exec rubocop src/
# Auto-correct the linter errors
$ bundle exec rubocop -a src/
```

If you think the remaining linter errors are acceptable, do not add any `rubocop` in-line comments in the code.<br>
This project uses a `rubocop_todo.yml` file that is generated. Do not modify this file manually.<br>
To update it, run the following command:

```bash
$ bundle exec rubocop --auto-gen-config src/
```
