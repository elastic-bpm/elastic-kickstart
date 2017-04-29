cd ~

# Shut down prev version
cd elastic-bpm
docker-compose down
cd ~

# Remove prev version
rm elastic-bpm/ -rf

# Clone new version
git clone https://github.com/elastic-bpm/elastic-bpm.git

# Build it
cd elastic-bpm
docker-compose build

# Start it
docker-compose up -d

