# Gégène (WIP)

Gégène is a **Meili's internal tool** to generate the `.code-samples` file (available in the MeiliSearch SDKs) based on the already existing tests suite of the SDK.<br>
**This way, we can ensure the code snippets are tested and up-to-date.**

#### More context

Each MeiliSearch SDK provides a `.code-samples.meilisearch.yaml` file containing code samples about the SDK usage. These specific files are used by the MeiliSearch documentation to generate code snippets in the [API References](https://docs.meilisearch.com/references/). See, [this example](https://docs.meilisearch.com/references/indexes.html#example).<br>
These code samples are currently manually written and can contain errors (typo, obsolete functions...).

_More about the [code-samples plugin](https://github.com/meilisearch/documentation/tree/master/.vuepress/code-samples) in the MeiliSearch documentation._

## Give a try!

```bash
$ bundle install
$ bundle exec ruby src/main.rb > .code-samples.meilisearch.yaml
$ cat .code-samples.meilisearch.yaml
```
