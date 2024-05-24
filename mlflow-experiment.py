import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import roc_auc_score, classification_report
from imblearn.pipeline import Pipeline as ImbPipeline
from imblearn.over_sampling import SMOTE
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.impute import SimpleImputer
from sklearn.model_selection import cross_validate
import mlflow
import mlflow.sklearn

# Set MLflow tracking URI
# mlflow.set_tracking_uri("http://127.0.0.1:5000")
mlflow.set_tracking_uri("http://34.243.99.237:5000")

# Load data
def load_data(filepath):
    df = pd.read_csv(filepath)
    return df

df = load_data('data/BankChurners.csv')

# Clean data
def clean_df(df):
    df = df[df.columns[:-2]]
    df = df.drop(['CLIENTNUM'], axis=1)
    return df

df = clean_df(df)

# Train-test split
X = df.drop('Attrition_Flag', axis=1)
y = df['Attrition_Flag']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Identify categorical and numerical columns
categorical_cols = X_train.select_dtypes(include=['object', 'category']).columns
numerical_cols = X_train.select_dtypes(exclude=['object', 'category']).columns

# Numerical preprocessing
numerical_pipeline = make_pipeline(
    SimpleImputer(strategy='mean'),
    StandardScaler()
)

# Categorical preprocessing
categorical_pipeline = make_pipeline(
    OneHotEncoder(handle_unknown='ignore')
)

# ColumnTransformer
preprocessor = ColumnTransformer(
    transformers=[
        ('cat', categorical_pipeline, categorical_cols),
        ('num', numerical_pipeline, numerical_cols) 
    ],
    remainder='passthrough'
)

# Define model with parameters manually
model_params = {
    'n_estimators': 200,
    'max_depth': 10,
    'min_samples_split': 2,
    'random_state': 42
}
model = RandomForestClassifier(**model_params)

# Pipeline with SMOTE
pipe = ImbPipeline([
    ('preprocessor', preprocessor),
    ('smote', SMOTE(random_state=42)),
    ('randomforestclassifier', model)
])

# Start MLflow run
with mlflow.start_run() as run:
    # Fit the model
    pipe.fit(X_train, y_train)

    # Log parameters
    mlflow.log_params(model_params)

    # Use the best estimator to make predictions
    y_pred = pipe.predict(X_test)
    y_proba = pipe.predict_proba(X_test)[:, 1]

    # Calculate and log metrics
    roc_auc = roc_auc_score(y_test, y_proba)
    mlflow.log_metric("roc_auc", roc_auc)

    # Log classification report
    report = classification_report(y_test, y_pred, output_dict=True)
    for key, value in report.items():
        if isinstance(value, dict):
            for sub_key, sub_value in value.items():
                mlflow.log_metric(f"{key}_{sub_key}", sub_value)
        else:
            mlflow.log_metric(key, value)

    # Log the model
    mlflow.sklearn.log_model(pipe, "model")

    # Print metrics
    print(f"ROC AUC: {roc_auc}")
    print(f"Classification Report:\n{classification_report(y_test, y_pred)}")

    # Perform cross-validation on the best estimator
    cv_results = cross_validate(pipe, X_train, y_train, cv=5, scoring='accuracy', return_train_score=True)

    # Log cross-validation results
    mlflow.log_metric("mean_test_accuracy", cv_results['test_score'].mean())
    mlflow.log_metric("mean_train_accuracy", cv_results['train_score'].mean())
    mlflow.log_metric("mean_fit_time", cv_results['fit_time'].mean())
    mlflow.log_metric("mean_score_time", cv_results['score_time'].mean())
