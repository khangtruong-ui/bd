from flask import Flask, request, jsonify
import pandas as pd
import numpy as np
from datetime import time
import joblib

# Load the model and encoder (assuming they are already saved and loaded in the notebook)
# If running this Flask app in a separate environment, ensure these files are accessible
# and loaded as shown in the previous cells.
model = joblib.load('pipeline.joblib')
enc = joblib.load('enc.joblib')

app = Flask(__name__)

# Re-define period_to_time function for completeness within the Flask context
def period_to_time(period_str):
  if isinstance(period_str, str):
    parts = period_str.replace('period_', '').split('_')
    hour = int(parts[0])
    minute = int(parts[1])
    return time(hour, minute, 0)
  return None

# Re-define predict_los function for completeness within the Flask context
def predict_los(examples: dict):
    # This assertion is commented out for more flexible API usage, 
    # but you might want to re-enable it for strict input validation.
    assert all(k in dummy_data.keys() for k in examples), f"You must have all these keys in the example: {dummy_data.keys()}"

    dummy_df = pd.DataFrame([examples]) # Wrap examples in a list to create a DataFrame with one row

    # Convert 'date' column to datetime objects (important for consistency with X if date is used as feature)
    dummy_df['date'] = pd.to_datetime(dummy_df['date']).dt.strftime('%Y-%m-%d')

    # Apply the period_to_time function to create the 'period_time' column
    dummy_df['period_time'] = dummy_df['period'].apply(period_to_time)

    predicted_los_numerical = model.predict(dummy_df)
    predicted_los_clipped = np.clip(predicted_los_numerical, 0., 5.9)
    predicted_los_category = enc.inverse_transform(predicted_los_clipped)

    results = predicted_los_category[0][0]
    return results

@app.route('/predict_los', methods=['POST'])
def api_predict_los():
    if request.is_json:
        data = request.get_json()
        try:
            prediction = predict_los(data)
            return jsonify({'predicted_los': prediction}), 200
        except Exception as e:
            return jsonify({'error': str(e)}), 400
    else:
        return jsonify({'error': 'Request must be JSON'}), 400

if __name__ == '__main__':
    # In Colab, you might need to use a tool like ngrok to expose your app
    # For local testing, you can run this directly.
    app.run(host='0.0.0.0', port=5000)
