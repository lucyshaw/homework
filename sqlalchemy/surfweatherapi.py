#import dependencies
from flask import Flask, jsonify
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

#create engine
engine = create_engine("sqlite:///hawaii.sqlite")

#reflect the tables
Base = automap_base()

Base.prepare(engine, reflect=True)

#display the classes
Base.classes.keys()

#save references for each table
Station = Base.classes.station
Measurement = Base.classes.measurement

#create session
session = Session(engine)

#turn sqlalchemy rows into dictionaries
def row2dict(row):
    d = {}
    for column in row.__table__.columns:
        d[column.name] = str(getattr(row, column.name))

    return d 

#start the flask
app = Flask(__name__)

@app.route('/')
def home():
    print('Server received request for home page')
    return(
        f'Welcome to the Hawaii Surfing Weather API!<br/>'
        f'Available routes:<br/>'
        f'Precipitation: /api/v1.0/precipitation<br/>'
        f'Weather Stations: /api/v1.0/stations<br/>'
        f'Temperature: /api/v1.0/tobs<br/>'
        f'Start Date: /api/v1.0/<start_date>YYYY-MM-DD<br/>'
        f'Trip Period: /api/v1.0/<start_date>YYYY-MM-DD/<end_date>YYYY-MM-DD<br/>'
    )

@app.route('/api/v1.0/precipitation')
def precip():
    print('Requested precipitation data')
    results = session.query(Measurement.date, Measurement.prcp).all()
    precip = [{result[0]: result[1]} for result in results]
    return jsonify(precip)

@app.route('/api/v1.0/stations')
def stations():
    results = session.query(Station).all()
    stations = [row2dict(station) for station in results]
    return jsonify(stations)
       
     
@app.route('/api/v1.0/tobs')
def temp():
    results = session.query(Measurement.date, Measurement.tobs).\
    filter(Measurement.date > '2016-08-23').all()

    temps = [{result[0]: result[1]} for result in results]
    return jsonify(temps)

@app.route('/api/v1.0/<start_date>')
def start_date(start_date):
    results = session.query(func.min(Measurement.tobs), func.max(Measurement.tobs), 
    func.avg(Measurement.tobs)).filter(Measurement.date >= start_date).first()

    return jsonify(results)
    
@app.route('/api/v1.0/<start_date>/<end_date>')
def trip_period(start_date, end_date):
    results = session.query(func.min(Measurement.tobs), func.max(Measurement.tobs), 
    func.avg(Measurement.tobs)).filter(Measurement.date >= start_date).filter(Measurement.date <= end_date).first()

    return jsonify(results)
        
if __name__ == "__main__":
    app.run(debug=True)
