echo "Оновлення системи..."
sudo apt-get update && sudo apt-get upgrade -y

echo "Встановлення базових утиліт (curl, tar, ssh)..."
sudo apt-get install -y curl tar build-essential openssh-client

echo "Створення робочої директорії..."
mkdir -p ~/actions-runner && cd ~/actions-runner

echo "Завантаження GitHub Actions Runner..."
curl -o actions-runner-linux-x64-2.316.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.316.1/actions-runner-linux-x64-2.316.1.tar.gz

echo "Розпакування архіву..."
tar xzf ./actions-runner-linux-x64-2.316.1.tar.gz

echo "Встановлення залежностей раннера..."
sudo ./bin/installdependencies.sh

echo "Базова підготовка завершена! Готово до ручної конфігурації."