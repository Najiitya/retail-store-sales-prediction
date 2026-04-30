import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error
import joblib #Used to save our trained AI model
import xgboost as xgb

print("Booting up the AI lab")

#Loding the datset
try:
    print("Loading 5 years of histotical data from csv file")
    df = pd.read_csv("train.csv")
    print(f"Loaded {len(df)} sales record")

except FileNotFoundError:
    print("Error Ouccured file not found")
    exit()

#Feature Engineering
#Helping AI to understand dates
#We should breake the date into number
print("Processing data into machine-readable features")
df['date'] = pd.to_datetime(df["date"])
df['year'] = df["date"].dt.year
df['month'] = df["date"].dt.month
df['day_of_week'] = df["date"].dt.day_of_week

#Predict the sales
X = df[['store', 'item', 'year', 'month', 'day_of_week']]
y = df['sales'] #The column that we anted to be predicted

#spliting the data 80%for training 20% for testing
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

#Training the XGBoost model
print("Training the XGBoost Model")
model = xgb.XGBRegressor(n_estimators=100, learning_rate=0.1, max_depth=5, random_state=42)
model.fit(X_train, y_train)

#Grading the AI Test
prediction = model.predict(X_test)
error = mean_absolute_error(y_test, prediction)
print(f"AI Training Complete! The model's average error margin is: {error:.2f} units per day.")

#Save AI to a file
joblib.dump(model, "sales_predictor.pkl")
print("AI successfully saved as 'sales_prediction.pkl'")