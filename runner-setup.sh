echo "System updating"
sudo apt-get update && sudo apt-get upgrade -y

echo "Installing curl, tar, etc..."
sudo apt-get install -y curl tar build-essential openssh-client

mkdir -p ~/actions-runner
cd ~/actions-runner || exit 1

curl -o actions-runner-linux-x64-2.316.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.316.1/actions-runner-linux-x64-2.316.1.tar.gz

tar xzf ./actions-runner-linux-x64-2.316.1.tar.gz

echo "Installing dependencies..."
sudo ./bin/installdependencies.sh

echo "Everything is ready."