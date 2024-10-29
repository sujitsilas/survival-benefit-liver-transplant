# Survival Benefit of Mechanically Ventilated Liver Transplant Patients

The project applies machine learning techniques and feature selection methods to assess the predictive power of different features and models, providing insights that may assist in clinical decision-making.

## Project Overview
Liver transplant patients who require mechanical ventilation present a unique clinical challenge. This study aims to model survival outcomes post-transplant by using various classification algorithms and feature selection techniques. The goal is to evaluate the survival benefit for mechanically ventilated patients and identify key predictors of positive outcomes along with the best fitting model.

## Methodology
**Minimal Depth Algorithm:** The minimal depth algorithm was used to assess the importance of different features within the Random Forest classifier. This helps in refining the feature set and improving model accuracy.

**Multiple Classifiers:** Several machine learning classifiers were used to predict survival outcomes. These include Logistic Regression, Random Forest, Support Vector Machines, and more.

**ROC Curves:** Receiver Operating Characteristic (ROC) curves were plotted for each model to visualize performance. These curves offer insights into the sensitivity vs. specificity trade-offs for each classifier.

## Key Results
Performance was measured using ROC curves, AUC (Area Under the Curve), and confusion matrices to evaluate the classifiers. The logistic regression model outperformed the rest with an AUC of 67% and a confidence interval (CI) of [0.59, 0.75].

## Conclusion
As the saying goes, "All models are wrong, but some are useful." In clinical tasks, simpler models like logistic regression seem to often outperform more complex ones, offering more reliable insights with less overfitting—proving once again that linear models tend to shine in healthcare applications.
