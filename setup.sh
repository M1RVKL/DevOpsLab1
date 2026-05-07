sudo apt update
sudo apt install -y nginx mariadb-server nodejs npm

echo "4" > /home/student/gradebook

sudo useradd -m -s /bin/bash teacher
echo "teacher:12345678" | sudo chpasswd
sudo passwd -e teacher

sudo useradd -r -s /usr/sbin/nologin mywebapp

sudo useradd -m -s /bin/bash student || true
echo "student:ytrewq" | sudo chpasswd
sudo usermod -aG sudo student

sudo useradd -m -s /bin/bash operator
echo "operator:12345678" | sudo chpasswd
sudo passwd -e operator

sudo bash -c 'cat <<EOF > /etc/sudoers.d/operator
operator ALL=(ALL) NOPASSWD: /usr/bin/systemctl start mywebapp.service
operator ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop mywebapp.service
operator ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart mywebapp.service
operator ALL=(ALL) NOPASSWD: /usr/bin/systemctl status mywebapp.service
operator ALL=(ALL) NOPASSWD: /usr/bin/systemctl reload nginx
EOF'

sudo mariadb -e "CREATE DATABASE IF NOT EXISTS inventory_db;"
sudo mariadb -e "GRANT ALL PRIVILEGES ON *.* TO 'vlad'@'localhost' IDENTIFIED BY 'qwerty';"
sudo mariadb -e "FLUSH PRIVILEGES;"

sudo cp ./configs/nginx.conf /etc/nginx/sites-available/mywebapp
sudo ln -sf /etc/nginx/sites-available/mywebapp /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

sudo cp ./configs/mywebapp.socket /etc/systemd/system/
sudo cp ./configs/mywebapp.service /etc/systemd/system/

sudo chown -R mywebapp:mywebapp $(pwd)
sudo chmod +x migrate.sh

sudo systemctl daemon-reload
sudo systemctl enable --now mywebapp.socket
sudo nginx -t && sudo systemctl restart nginx

sudo passwd -l miracle 

echo "Setup completed successfully!"