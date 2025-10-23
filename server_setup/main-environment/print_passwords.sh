for i in $(seq 1 50)
do
    echo -n "Username: user${i} | Password: "
    echo -n "user${i}icse26" | sha256sum | head -c 13
    echo ""
done
