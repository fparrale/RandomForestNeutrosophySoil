setwd("C:/Users/fparr/Documents/SOFT/Redes Bayesianas/FRPB-clases/Ejercicios/SoilPrediction")

# Load necessary libraries
library(tidyverse)
library(randomForest)
library(caret)
library(ggplot2)

# 1. Load and preprocess the soil dataset
data <- read.csv("FRPB-E-Soil-Fertility-Prediction.csv")

# Convert Output to factor with explicit level ordering
data$Output <- factor(data$Output, levels = c("Non Fertile", "Fertile"))

# Check structure and levels
str(data)
levels(data$Output)

# 2. Train-test split with consistent factor levels
set.seed(123)
train_indices <- createDataPartition(data$Output, p = 0.8, list = FALSE)
trainData <- data[train_indices, ]
testData <- data[-train_indices, ]

# Verify factor levels match in both sets
stopifnot(identical(levels(trainData$Output), levels(testData$Output)))

# 3. Train Random Forest model
rf_model <- randomForest(Output ~ ., 
                         data = trainData,
                         ntree = 100,
                         importance = TRUE,
                         keep.forest = TRUE)

# 4. Get predictions and probabilities
predictions <- predict(rf_model, newdata = testData)
probabilities <- predict(rf_model, newdata = testData, type = "prob")

# Verify probability matrix structure
print(colnames(probabilities))
stopifnot(all(colnames(probabilities) == levels(testData$Output)))

# 5. Enhanced neutrosophic function with error handling
compute_neutrosophic_values <- function(prob_row, actual) {
  # Convert to consistent character representation
  actual_char <- as.character(actual)
  
  # Safe probability extraction
  correct_prob <- prob_row[, actual_char, drop = TRUE]
  
  # Neutrosophic thresholds
  if (correct_prob >= 0.9) {
    return(c(T = 0.9, I = 0.1, F = 0.0))
  } else if (correct_prob >= 0.7) {
    return(c(T = 0.7, I = 0.2, F = 0.1))
  } else if (correct_prob >= 0.5) {
    return(c(T = 0.5, I = 0.3, F = 0.2))
  } else {
    return(c(T = 0.2, I = 0.3, F = 0.5))
  }
}

# 6. Apply neutrosophic interpretation safely
neutrosophic_results <- t(sapply(1:nrow(testData), function(i) {
  compute_neutrosophic_values(probabilities[i, , drop = FALSE], testData$Output[i])
}))

# 7. Create comprehensive results dataframe
results <- data.frame(
  Actual = testData$Output,
  Predicted = predictions,
  Fertile_Prob = probabilities[, "Fertile"],
  NonFertile_Prob = probabilities[, "Non Fertile"],
  T = neutrosophic_results[, "T"],
  I = neutrosophic_results[, "I"],
  F = neutrosophic_results[, "F"],
  stringsAsFactors = FALSE
)

# 8. Performance evaluation
conf_matrix <- confusionMatrix(predictions, testData$Output)
print(conf_matrix)

# 9. Visualization
# Feature importance
varImpPlot(rf_model, main = "Soil Fertility Predictor Importance")

# Neutrosophic values plot
ggplot(results, aes(x = Fertile_Prob)) +
  geom_point(aes(y = T, color = "Truth")) +
  geom_point(aes(y = I, color = "Indeterminacy")) +
  geom_point(aes(y = F, color = "Falsity")) +
  labs(x = "Probability of Fertile", 
       y = "Neutrosophic Values",
       title = "Prediction Confidence Spectrum") +
  scale_color_manual(values = c("Truth" = "blue", 
                                "Indeterminacy" = "orange", 
                                "Falsity" = "red")) +
  theme_minimal()
