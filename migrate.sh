cd /var/www/mywebapp

export HOME=/tmp

export DATABASE_URL="mysql://vlad:qwerty@localhost:3306/inventory_db"

echo "Starting database migration..."

./node_modules/.bin/prisma migrate deploy

if [ $? -eq 0 ]; then
    echo "Migration completed successfully"
    exit 0
else
    echo "Migration failed"
    exit 1
fi