#! /bin/bash
# export db tables as interfaces
npm install
mkdir db

npx @rmp135/sql-ts -c ./sql.json -o ./db

# agregar endline despues de }, quitar ''
sed -i "1,4d; s/}/}\n/; s/'//g" ./db/Database.ts


# awk separa un interface por archivo
awk -v RS="\n\n" '{print $0 > "./db/"$1NR".ts"}' ./db/Database.ts

# cambiar nombre a nombre de interfaz
for file in ./db/export*; do
    FILENAME=$(head -n 1 $file | cut -d " " -f 3)
    mv $file ./db/$FILENAME.ts
done
