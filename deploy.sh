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
gcloud app deploy market_place/build/web/app.yaml snake_game/dist/app.yml dino_game_node/dist/app.yml
