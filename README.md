
# Soil Fertility Prediction using Random Forest and Neutrosophic Interpretation

This project implements a Random Forest-based classifier to predict soil fertility based on a dataset of soil attributes. Additionally, it introduces a novel post-processing step using **Neutrosophic Logic** to express prediction confidence through degrees of **Truth (T)**, **Indeterminacy (I)**, and **Falsity (F)**.

## 📁 Files

- `SoilNeutrosophyRandomForestV2.R`: Main R script containing all steps from data loading to model training, prediction, neutrosophic interpretation, and visualization.
- `FRPB-E-Soil-Fertility-Prediction.csv`: Dataset file (you must provide this in the working directory).

## 🚀 Features

- Random forest classification to distinguish between **Fertile** and **Non Fertile** soil samples.
- Customized **neutrosophic interpretation** of prediction probabilities to enhance decision transparency.
- Performance evaluation via confusion matrix.
- Visualization of feature importance and neutrosophic value spectrum.

## 📦 Dependencies

Make sure to install the following R packages before running the script:

```r
install.packages(c("tidyverse", "randomForest", "caret", "ggplot2"))
```

## 📊 Output

- A trained Random Forest model with variable importance plot.
- A confusion matrix to evaluate classifier performance.
- A custom plot showing how predictions are mapped to neutrosophic values based on probability thresholds.

## 🧠 Neutrosophic Mapping Logic

The mapping of probabilities to `(T, I, F)` values is based on simple heuristics:

| Probability (Correct Class) | T    | I    | F    |
|-----------------------------|------|------|------|
| ≥ 0.9                       | 0.9  | 0.1  | 0.0  |
| ≥ 0.7                       | 0.7  | 0.2  | 0.1  |
| ≥ 0.5                       | 0.5  | 0.3  | 0.2  |
| < 0.5                       | 0.2  | 0.3  | 0.5  |

This aims to provide a more nuanced view of classification confidence.

## 📍 How to Run

1. Place the CSV file (`FRPB-E-Soil-Fertility-Prediction.csv`) in your working directory.
2. Open the R script and set your working directory if needed (`setwd()`).
3. Run the script section by section or entirely to execute the pipeline.

## 🧾 License

This project is provided under the MIT License.

## 🙋‍♂️ Author

Developed by [Your Name]. For academic or research-related questions, feel free to reach out.
