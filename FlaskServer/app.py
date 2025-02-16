from flask import Flask, jsonify
from pymongo import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv
import os

#Load .Env
load_dotenv()

#Access Env Variables
dbPassword = os.getenv("DB_PASSWORD")

app = Flask(__name__)

# MongoDB Atlas connection
print(dbPassword)
db_uri = "mongodb+srv://Martineus:Hacklahoma@mbdatabase.heuls.mongodb.net/?retryWrites=true&w=majority&appName=MBDatabase"
client = MongoClient(db_uri, server_api=ServerApi('1'))
db = client.get_database("Hacklahoma")
collection = db.get_collection("Scenarios")
print(collection.find())
print(db.get_collection("Scenarios"))


@app.route('/scenarios', methods=['GET'])
def get_scenarios():
    scenarios = list(db.get_collection("Scenarios").find({}, {'_id': 0}))  # Exclude the MongoDB _id field
    return jsonify(scenarios)

if __name__ == '__main__':
    app.run(port=5000)
