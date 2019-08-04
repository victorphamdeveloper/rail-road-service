Build & run instruction:
1. Go to project folder

2. RUN: docker build -t test .

3. RUN: docker run -p 3000:3000 test

Test with curl:

curl -X GET http://localhost:3000/find_routes\?source\=Holland%20Village\&destination\=Bugis

curl -X GET http://localhost:3000/find_routes_bonus\?source\=Boon%20Lay\&destination\=Little%20India\&time\=2019-08-05T07:00

*All unit tests are in spec folder
