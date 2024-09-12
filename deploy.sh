# Setup gcloud
echo "Listing projects"
gcloud projects list
echo "Specify the project ID for deployment"
project_id=""
read project_id
if [ -z "$project_id" ]
then
    echo "Project ID is empty"
    exit 1
fi

gcloud config set project $project_id

# Prepare market_place for deployment
echo "Preparing market_place for deployment"
cd ./market_place/
flutter build web --release 
cp app.yaml build/web/
cd ../

# Prepare dinogame for deployment
echo "Preparing dino_game for deployment"
cd dino_game_node/
npm install
npm run build
cp app.yml dist/
cd ../

# Prepare snakegame for deployment
echo "Preparing snake_game for deployment"
cd snake_game/
npm install
npm run build
cp app.yml dist/
cd ../

# Deploy
echo "Deploying to Google Cloud"
gcloud app deploy --project $project_id gcloud_dummy/app.yaml market_place/build/web/app.yaml snake_game/dist/app.yml dino_game_node/dist/app.yml
