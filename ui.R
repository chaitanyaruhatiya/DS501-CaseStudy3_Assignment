################
###Chaitanya Ruhatiya
###DS-501 Fall 2022 Case Study-3
###############

library(shiny)
library(shinydashboard)
library(dplyr)
library(shinycssloaders)
library(shinythemes)
library(DT)
library(DataExplorer)


var_name <- names(GTdata)

dashboardPage(
  dashboardHeader(title = "Gas Turbine Energy Yield Predictive Analysis", titleWidth = "720px"), skin = "yellow",
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidPage(
    
      box(sliderInput("Slider", label = NULL, min = 0, max = 100, value = 80),
      solidHeader = TRUE,
      width = "5",
      status = NULL,
      title = "Set Training and Testing Data:",
      background = "yellow",
      tags$h5(strong("Slider input for multivariate model only"))
      ),
      
      box(
        selectInput("TargetVar", label = "Select variable to predict (Prediction):",choices = var_name, selected = var_name[8]),
        solidHeader = TRUE,
        width = "2",
        status = NULL,
        background = "yellow"
      )
    ),
    
    fluidPage( 
      theme = shinytheme("sandstone"),
      tabBox(
        height = "1440px",
        width = 16,
        tabPanel(
          title = "Algorithm and Dataset",
          tags$h3(strong("About Dataset:")),
          p(tags$h5("     The datatset contains 7411 numerical instances of 11 sensor measured data aggregated over one hour from a gas turbine
                  situated in Turkey's north western region for the purpose of studying flue gas emissions which is made
                  up of CO and NOx (NO + NO2). The data comes from the same power plant as the dataset used for predicting hourly
                  net energy yield(",tags$a(href = "http://archive.ics.uci.edu/ml/datasets/Combined+Cycle+Power+Plant", "http://archive.ics.uci.edu/ml/datasets/Combined+Cycle+Power+Plant"),
                    ").By contrast, this data is collected in another data range (01.01.2011 - 31.12.2015), includes
                  gas turbine parameters (such as Turbine Inlet Temperature and Compressor Discharge pressure) in addition to the
                  ambient variables. Note that the dates are not given in the instances but the data are sorted in chronological
                  order. The dataset can be well used for predicting turbine energy yield (TEY) using ambient variables as features. For this prediction
                  analysis, only data from year 2011 was used for training and testing. This was done to test bare bone model viability on medium size dataset. Additional details on dataset
                  is illustrated in", strong("Data Statistics tab section"), "with summary and coorelation.", style="text-align: justify;")),
          
          tags$h5("Data was collected from UCI Machine Learning Repository, Link to dataset:",tags$a(href = "https://archive.ics.uci.edu/ml/datasets/Gas+Turbine+CO+and+NOx+Emission+Data+Set", "https://archive.ics.uci.edu/ml/datasets/Gas+Turbine+CO+and+NOx+Emission+Data+Set")),
          tags$h5("Variables used (abbreviations and units):"),
          tags$h5("AT - Ambient Temperature (Celsius)"),
          tags$h5("AP - Ambient Pressure (mbar)"),
          tags$h5("AH - Ambient Humidity (%)"),
          tags$h5("AFDP - Air filter difference pressure (mbar)"),
          tags$h5("GTEP - Gas turbine exhaust pressure (mbar)"),
          tags$h5("TIT - Turbine inlet temperature (Celsius)"),
          tags$h5("TAT - Turbine after temperature (Celsius)"),
          tags$h5("CDP - Compressor discharge pressure (mbar)"),
          tags$h5("TEY - Turbine energy yield (MWh)"),
          tags$h5("CO - Carbon Monoxide (mg/m",tags$sup("3"),")"),
          tags$h5("NOx - Nitrogen oxides (mg/m",tags$sup("3"),")"),
          
          tags$h3(strong("About Algorithm:")),
          p(tags$h5("The algorithm chosen for this multivariate dataset is", strong("Regression model."), "The reason for choosing regression analysis is obvious,
                    since we plan on predicting turbine energy yield (TEY) based of various process variables and ambient condition parameters.
                    The regression analysis was performed on given dataset to produce a multivariate model which could predict energy yield for
                    turbine based of external control variables with good accuracy and robustness. Ideally this type of model could be employed by power industry for
                    understanding and predicting energy loads in different ambient/climate conditions.", style="text-align: justify;")),
          
          p(tags$h5("The basic understanding of regression is concerned with formulating a relationship between a dependent variable (single variable whose
                    value is to be predicted) and one or more independent or control variables. It may happen that independent variables are not truly orthogonal
                    and may have interdependencies like for example process variables in complex chemical filtration plant. we don't just predict the outcome; we
                    also have an understanding of how variability in individual drivers/control parameters affect the outcome variable. Specifically linear regression
                    is used to estimate a continuous value as a linear (additive) function of other variables, this function can be then used as empirical relation to
                    predict outcome for that particular problem. This function has a set of coefficients associated with it indicative of the relative impact of each
                    input driver. The input or predictor variable can be continuous, discrete or categorical. Simple linear regression is the preferred method
                    for almost any problem where outcome is continuous, this method is tried before trying any complicated approach. After data collection, we
                    have pairs of observations , each having one response and predictor variable values. The idea is to formulate a best fit line which represents
                    this scatter data as closely as possible, this is done by estimating unknown parameters of linear equation by minimizing the residual values, one
                    of such parameters of evaluation is least squares method. Further, the generated model should be evaluated. This is done by calculating coefficient
                    of determination (R-squared value) and root mean squared error for prediction (RMSEP). ", style="text-align: justify;"))
        ),
        tabPanel(
          title = "Motivation",
          tags$h3("What data you collected?"),
          p(tags$h5("It is a Gas Turbine CO and NOx Emission Data Set, and more details are provided in Algorithm and Dataset tab of App. Data was collected from UCI Machine Learning Repository, Link to dataset:",tags$a(href = "https://archive.ics.uci.edu/ml/datasets/Gas+Turbine+CO+and+NOx+Emission+Data+Set", "https://archive.ics.uci.edu/ml/datasets/Gas+Turbine+CO+and+NOx+Emission+Data+Set"))),
          tags$h3("Why this topic is interesting or important to you? (Motivation)"),
          p(tags$h5("In my undergraduate while pursuing mechanical engineering major I was involved in few projects which dealt with design and modelling of gas
                  turbine engines, this involved extensive use of theoretical-physics modelling, thermal and fluid dynamics analysis. All this approach were empirical
                  and mathematics heavy. Undertaking this case study has opened up a whole new paradigm for me, this case study doesn’t involve any mathematical
                  formulation of domain, and its purely data driven approach. Which helps someone from minimal domain knowledge to make decision. The main motivation
                  for me was to take this sensor data and formulate a model which could predict turbine energy yield based of ambient climate parameters. This could
                  be a really helpful tool, where we can predict energy output of a power plant based of various external out of control parameters. This could
                  further help load sharing and energy management in adverse climate conditions.", style="text-align: justify;")),
          tags$h3("How did you analyze the data?"),
          p(tags$h5("The dataset was evaluated for cleaning, then it was summarized to understand all involved attributes. The parameter TEY (MWh) is the target variable.
                    The correlation matrix was used to understand interdependencies of predictor and outcome variable. Then a regression model was applied to formulate model,
                    which was finally evaluated for its accuracy. All the details are available in data statistics, simple linear regression, multivariate model, and evaluation tabs.
                    ", style="text-align: justify;")),
          tags$h3("What did you find in the data? (please include figures or tables in the report)"),
          p(tags$h5("From simple linear regression and correlation matrix it was clear that target variable TEY is closely related to AFDP (0.9), TIT (0.9), CDP (1),
                    and GTEP (1). These are the predictor factors which have significant effect on variability of TEY. The multivariate best fit model for target
                    variable has good fit with slope of fit line around ~ 0.98 and RSME of 0.735. Many a times model may overfit and lead to wrongful results.
                    That was not observed here. It was observed that, target values were getting grouped/clustered into three seperate regions with respect to TEY value for ambient predictor
                    variables like AP, AT, AH as indicated by simple linear regression tabs plot. This shows how ambient conditions affect and control efficiency
                    and yields of gas turbines. Further, this model can be used to map favorable ambient condition ranges to attain high energy yields.
                    More details with tables and graphs are provided in multivariate model, and evaluation tabs with user-end functionality to
                    change train-test split, change target variables etc. Thank you!", style="text-align: justify;"))
        ),
      
        tabPanel(
          "Data Statistics",
          box(withSpinner(verbatimTextOutput("data_stat")), width = 6, title = "Data Summary:"),
          box(withSpinner(plotOutput(
                        "Corr_matx", width = "100%", height = "480px"
                      )), width = 6, title = "Correlation Matrix:")
        ),
        
        
        tabPanel(
          "Multivariate Model",
          box(
            withSpinner(verbatimTextOutput("details")),
            title = "Model Details:"
          ),
          
          box(
             withSpinner(verbatimTextOutput("coeff")),
             title = "Model Coefficient values for Fitting Eqn:"
          ),
          
          box(
            withSpinner(verbatimTextOutput("imp_comp")),
            title = "Most Important Variables (Decreasing order):"
          )
        ),

        tabPanel(
          title = "Multivariate Model Evaluation",
          tags$h4(" Actual vs Predicted with Best fit line for selected variable:"),
          fluidRow(
          column(6,
          plotOutput('multivariate', width = "100%", height = "480px"),
          uiOutput("rmse"),
          uiOutput("sse"),
          uiOutput("rse"),
          uiOutput("f1"),
          uiOutput("bias"),
          uiOutput("num_traindata"),
          uiOutput("num_testdata")
          ),
          column(6,
          plotOutput('evaluation',width = "100%", height = "480px")
          )
        )),
      
        tabPanel(
          title = "Simple Linear Regression",
          fluidRow(
            column(4,
                   selectInput('x_var', 'X Variable', var_name),
                   selectInput('y_var', 'Y Variable', var_name, selected = var_name[5])),
            column(8,
                   plotOutput('slr'),
                   uiOutput("reg_values")))
        )
      )
    )
  )
)