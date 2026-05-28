#!/bin/sh
while ! nc -z db 3306; do
  sleep 1
done

echo "База даних готова. Запуск міграцій..."
npx prisma migrate deploy

exec node index.js