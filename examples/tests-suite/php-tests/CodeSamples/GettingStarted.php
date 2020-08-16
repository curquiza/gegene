<?php

declare(strict_types=1);

namespace Tests\Endpoints;

// GEGENE getting_started_create_index_md => nb_lines: 11
// ```bash
// $ composer require meilisearch/meilisearch-php
// ```
//
// ```php
// <?php
//
// require_once __DIR__ . '/vendor/autoload.php';
//
use MeiliSearch\Client;
//

use Tests\TestCase;

final class GettingStartedTest extends TestCase
{
    public function completeGettingStarted(): void
    {
        // GEGENE getting_started_create_index_md => nb_lines: 5 ; replacer: $movies_index $index
        $client = new Client('http://127.0.0.1:7700');
        $movies_index = $client->createIndex('movies');
        // ```
        //
        // [About this package](https://github.com/meilisearch/meilisearch-php/)

        $this->assertSame('movies', $movies_index->getUid());
        $this->assertNull($movies_index->getPrimaryKey());

        // GEGENE getting_started_add_documents_md => nb_lines: 4 ; replacer: ../datasets/movies.json movies.json ; replacer: $movies_index $index
        // ```php
        $movies_json = file_get_contents('../datasets/movies.json');
        $movies = json_decode($movies_json);
        $promise = $movies_index->addDocuments($movies);

        // GEGENE getting_started_add_documents_md => nb_lines: 3
        // ```
        //
        // [About this package](https://github.com/meilisearch/meilisearch-php/)

        $this->assertIsValidPromise($promise);
        $movies_index->waitForPendingUpdate($promise['updateId']);

        $response = $movies_index->getDocuments();
        $this->assertCount(20, $response);
        $this->assertSame(19654, $movies_index->stats['numberOfDocuments']);

        // GEGENE getting_started_search_md => nb_lines: 2 ; replacer: $movies_index $index
        // ```php
        $search = $movies_index->search('botman');

        // GEGENE getting_started_search_md => nb_lines: 3
        // ```
        //
        // [About this package](https://github.com/meilisearch/meilisearch-php/)

        $this->assertCount(20, $search['hits']);
        $this->assertSame('botman', $search['query']);
    }
}
