#!/bin/bash

# Set values for your Search service
<<<<<<< HEAD
url=YOUR_SEARCH_URL
admin_key=YOUR_ADMIN_KEY
=======
url="https://fla-ai-search-service.search.windows.net"
admin_key="YOUR_ADMIN_KEY"
>>>>>>> ee5b848 (Removed keys)

echo "-----"
echo "Updating the skillset..."
curl -v -X PUT "$url/skillsets/margies-skillset?api-version=2020-06-30" -H "Content-Type: application/json" -H "api-key: $admin_key" -d @skillset.json

# Wait for 2 seconds
sleep 2

echo "-----"
echo "Updating the index..."
curl -v -X PUT "$url/indexes/margies-index?api-version=2020-06-30" -H "Content-Type: application/json" -H "api-key: $admin_key" -d @index.json

# Wait for 2 seconds
sleep 2

echo "-----"
echo "Updating the indexer..."
curl -v -X PUT "$url/indexers/margies-indexer?api-version=2020-06-30" -H "Content-Type: application/json" -H "api-key: $admin_key" -d @indexer.json

echo "-----"
echo "Resetting the indexer..."
curl -v -X POST "$url/indexers/margies-indexer/reset?api-version=2020-06-30" -H "Content-Type: application/json" -H "Content-Length: 0" -H "api-key: $admin_key"

# Wait for 5 seconds
sleep 5

echo "-----"
echo "Rerunning the indexer..."
curl -v -X POST "$url/indexers/margies-indexer/run?api-version=2020-06-30" -H "Content-Type: application/json" -H "Content-Length: 0" -H "api-key: $admin_key"
