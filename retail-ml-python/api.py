from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd
import joblib

#Initialize the app
app = FastAPI(title="Retail AI Predictor")

#Load the trained AI brain
try:
    print("Loading AI model")
    model = joblib.load('sales_predictor.pkl')
    print("AI model loaded successfully")
except Exception as e:
    print("ERROR: Could not find 'sales_predictor.pkl'. Did you run train_model.py first?")
    model = None

class PredictionRequest(BaseModel):
    store: int
    item: int
    year: int
    month: int
    day_of_week: int

@app.post("/predict")
def predict_sales(request: PredictionRequest):
    if model is None:
        raise HTTPException(status_code=500, detail="AI model is not loaded")
    # Convert the incoming JSON into a format the AI understands (Pandas DataFrame)
    input_data = pd.DataFrame([{
        'store': request.store,
        'item': request.item,
        'year': request.year,
        'month': request.month,
        'day_of_week': request.day_of_week
    }])

    #Ask AI for a prediction
    prediction = model.predict(input_data)

    #retrun the answer
    return {
        "store": request.store,
        "item": request.item,
        "predicted_sales": int(round(prediction[0]))
    }

@app.get('/')
def health_check():
    return {"status": "online", "message": "Retail AI is ready for predictions."}