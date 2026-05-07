echo "Starting database migration"

npx prisma migrate deploy

if [ $? -eq 0 ]; then
    echo "Migration completed"
    exit 0
else
    echo "Migration failed"
    exit 1
fi