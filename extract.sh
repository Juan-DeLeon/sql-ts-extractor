#! /bin/bash
# export db tables as interfaces
rm -rf db
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

rm ./db/Database.ts

# lista de archivos a index.ts
ls ./db > ./db/index.ts

# export de ts para todas las interfaces
awk -i inplace -v RS=".ts\n" '{print "export { "$0" } from \"./"$0"\";" }' ./db/index.ts
