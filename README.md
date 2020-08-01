# Gégène

Gégène is a Meili's internal tool used for a specific use-case. Each MeiliSearch SDK provides a `.code-samples.meilisearch.yaml` file containing code samples about the SDK usage. These specific files are used by the MeiliSearch documentation to generate code snippets in the [API References](https://docs.meilisearch.com/references/). See, [this example](https://docs.meilisearch.com/references/indexes.html#example).
These code samples are manually written and can contain errors (typo, obsolete functions...).

The goal of Gégène is to generate this `.code-samples` file based on the already existing tests suite of the SDK.<br>
This way, we can ensure the code snippets are tested and up-to-date.

_More about the [code-samples plugin](https://github.com/meilisearch/documentation/tree/master/.vuepress/code-samples) in the MeiliSearch documentation._
