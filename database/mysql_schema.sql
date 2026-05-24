   test-mysql:
    runs-on: ubuntu-latest
    services:
      mysql:
        image: mysql:8
        env:
          MYSQL_ROOT_PASSWORD: Join0253
          MYSQL_DATABASE: library_db
          MYSQL_USER: root
          MYSQL_PASSWORD: Join0253
        ports:
          - 3306:3306
        options: >-
          --health-cmd="mysqladmin ping -h localhost -u root -pJoin0253"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=5

    steps:
      - uses: actions/checkout@v4
      
      - name: Install MySQL client
        run: sudo apt-get update && sudo apt-get install -y mysql-client
      
      - name: Wait for MySQL
        run: |
          for i in {1..30}; do
            if mysqladmin ping -h 127.0.0.1 -u root -pJoin0253 &> /dev/null; then
              echo "MySQL is ready"
              break
            fi
            echo "Waiting for MySQL..."
            sleep 2
          done
      
      - name: Run MySQL schema
        run: |
          mysql -h 127.0.0.1 -u root -pJoin0253 library_db -e "SOURCE database/mysql_schema.sql;"
      
      - name: Test MySQL connection
        run: |
          mysql -h 127.0.0.1 -u root -pJoin0253 library_db -e "SELECT COUNT(*) as books FROM books;"
