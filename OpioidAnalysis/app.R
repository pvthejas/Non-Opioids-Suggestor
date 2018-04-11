rm(list = ls())
gc()

# install.packages("highcharter")

##### Load required packages
library(shiny)
library(highcharter)
library(ggplot2)
library(plotly)

##### Read in data/scripts
# source("src/year_drug_abuse.R")
source("src/addictionRateGraph.R")
source("src/CMS_drug_cost_boxplot.R")
source("src/Top5SideEffects.R")

ui <- navbarPage(title=div("How Coverage Affects Addiction: Rates and Cost", img(src="unitedhealth.png", width="15%", align="right", alt="United Healthcare")),
  
  #titlePanel(windowTitle = "Opioid Analysis", title=div(img(src="uw-logo.png"), "Opioid Analysis")),
  tabPanel("Decision",
    fluidRow(
      column(6, offset = 3,
        h4(style="padding:15px;",
          "Final Decision"
        ),
        h5(style="padding:15px;",
           "There are a few different decisions that could be made in this domain: 
           Overhaul United Healthcare's formulary to switch all coverage to opioid alternatives, 
           make smaller adjustments to their list, or make no changes. From the analysis provided 
           in this app, we would recommend the second decision: to not overhaul the entire list from
           opioids to non-opioids, but make small adjustments to which drugs are covered even if it
           means keeping some opioids."
        ),
        h5(style="padding:15px;",
          "When comparing opioids versus alternatives in terms of their addiction rates, both groups 
          had roughly the same rates towards the present day. Additionally, most drugs in our app have
          shown large numbers of drug ineffectiveness and pain reports, listed somewhere within their 
          top 5 most reported adverse events. This indicates that when it comes to safety and effectiveness,
          opioids and alternatives are similar enough that switching entirely from one group to another would 
          not warrant significant changes in these two factors."
        ),
        h5(style="padding:15px;",
          "However, a noticeable difference between these two groups can be discerned when 
          looking at their costs. Alternative prescription drugs were generally cheaper for 
          insurance companies to cover than opioids. For instance, no range of claim costs for 
          alternatives ever went over $1000, which cannot be said for opioids."
        ),
        h5(style="padding:15px;",
           "We would suggest United Healthcare to consider more alternatives to cover not because 
           they are less addictive or more effective in treating pain than opioids, but for their smaller 
           costs on their end. For instance, the alternative drug Voltaren is the cheapest drug 
           United Healthcare does not cover, a more affordable option compared to opioids they 
           currently cover such as Butrans and Fentanyl."
        )
      ) 
    )
  ),
 
  tabPanel("Addiction Rates",
    fluidRow(
      column(6, offset=3, 
        h5("The default selection of drugs is what is currently covered by United Healthcare. 
           Use the buttons underneath the below graph to compare the addiction rates of these 
           selected drugs"
      )),
      column(6, style="padding:0px;", wellPanel(
        checkboxGroupInput("opioids", "Opioids:",
                           choices = list("Avinza", "Butrans", "Fentanyl", "Oxycontin", "Percocet", "Tramadol", "Vicodin"),
                           selected = list("Butrans", "Fentanyl", "Tramadol"))
      )),
      column(6, style="padding:0px;", wellPanel(
        checkboxGroupInput("alts", "Alts:",
                           choices = list("Cymbalta", "Etodolac", "Gabapentin", "Lyrica", "Naprosyn", "Suboxone", "Voltaren"),
                           selected = list("Etodolac","Gabapentin", "Lyrica", "Suboxone"))
      ))
    ),
    fluidRow(
      column(12,
             highchartOutput("AddictionGraph", height = 800)
             
      )
    )
  ),
  
  tabPanel("Cost of Treatment",
    fluidRow(
        h3(textOutput("DrugCost"))
    ),
    fluidRow(
      h3("Drug Costs"),
      column(12, plotOutput("DrugCosts"))
    )
      
    #   column(3, style="padding:0px;", wellPanel(
    #     selectInput("drugCost", "Drug:", 
    #                 choices = list(`Opioid` = c("Buprenophine", "Fentanyl", "Hydrocodone", "Morphine", "Oxycontin", "Percocet", "Vicodin"),
    #                                `Alternative` = c("Butrons", "Indocin", "Lodine", "Lyrica", "Naprosyn", "Suboxone", "Voltaren")),
    #                 selected = "Hydrocodone")
    #   ))
  ),
  
  tabPanel("Other Side Effects",
    fluidRow(
      h3(textOutput("DrugEffect"))
    ),
    fluidRow(
      h3("Drug Effect"),
      column(6, style="padding:0px;", wellPanel(
        selectInput("drugEffect", "Drug:", 
                    choices = list(`Opioid` = c("Avinza", "Butrans", "Fentanyl", "Oxycontin", "Percocet", "Tramadol", "Vicodin"),
                                   `Alternative` = c("Cymbalta", "Etodolac", "Gabapentin", "Lyrica", "Naprosyn", "Suboxone", "Voltaren")),
                    selected = "Avinza")
      ))
    ),
    fluidRow(
      column(12,
             plotlyOutput("dEffect")
             
      )
    )
  ),
  
  tabPanel("About",
    fluidRow(
      column(6, offset = 3,
             h5(style="padding:4px;", "What are ways in which we can lower the opioid addiction rate in the US? Today, pharmaceuticals 
                profit big off of the widespread adoption of opioid prescriptions, with products such as Oxycontin. However, with this 
                wide adoption has come over-prescription by doctors and widespread abuse by the public. Patients can become addicted to 
                opioids, while others have stolen them or bought them illegally for recreational use, creating a black market. The federal 
                government is now tasked with cracking down on this market, while also providing rehabilitation resources. In short, 
                opioid addiction is a domain that has far reaching consequences within our society, and lowering addiction rates is something 
                most stakeholders are interested in seeing."
             ),
             h5(style="padding:4px;", "We aim to inform health insurance providers on the success rates, profitability, and popularity 
                of alternative pain-relief methods and medicine to package with insurance plan coverages. This web app helps us to achieve 
                that by showing an analysis of past addiction rates with errors due to underreporting bias, prediction of addictions rates 
                shown by regression line, cost of treatment, as well as side effects of various opioid and alternative drugs. We used the 
                openFDA and CMS API to get data from the FDA Adverse Event Reporting System and CMS database to create our graphs. The graphs 
                are interactive, so users can test and compare whichever drugs they wish to see. We hope that by allowing health insurnace 
                providers to interact with these analyses in ways that are tailored their interests and needs, we can influence their 
                decisions on which prescriptions drugs to be covered and to have cost lowered, as they can potentially have a significant 
                influence in the opioid epidemic."
             ),
             h5(style="padding:4px;",
                "Our team paid close attention to the process of how insurance companies actually decide on 
                prescription drug coverage, attempting to measure the same factors and use similar sources of data. 
                These factors include a drug's effectiveness in treating pain, overal safety, and cost to 
                insurance companies of covering. Accordingly, we pulled data from the CMS and FDA to visualize 
                addiction rates, costs, and additional side effects, which we believed United Healthcare would be 
                interested in referencing when making these decisions on drug coverage."
             ),
             h5(style="padding:4px;",
                 "The addiction rates graph visualizes the prescription drugs currently covered 
                 by United Healthcare by default. This data is pulled from the FDA Adverse Dug Events 
                 (ADE) API, which has a severe underreporting bias due to relying on voluntary submitting 
                 from doctors and consumers to gain reports. Our team attempted to mitigate this bias 
                 by implementing a reporting error range taken from a previous study on this exact issue 
                 in the ADE dataset. This study found that the number of reports from the FDA only accounted for 
                 0.071% to 44.67% of actual reports."
             )
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  #h <- drug_addiction_graph_base(data)
  
  output$AddictionGraph <- renderHighchart({
    # l <- length(input$opioids + input$alts)
    c <- colors(15)
    hc <- drug_addiction_graph_base(c[1])
    if (length(input$opioids) > 0) {
      hc <- addiction_graph(hc, input$opioids, c[2:(length(input$opioids) + 1)])      
    }
    if (length(input$alts) > 0) {
      hc <- addiction_graph(hc, input$alts, c[(length(input$opioids) + 2):15])      
    }
      # hc_plotOptions(scatter = list(lineWidth = 2))
    # hc_tooltip(split = TRUE)
    return(hc)
  })
  
  output$DrugCosts <- renderPlot(
    return(cost_graph())
  )
  
  # output$Opioids <- renderPrint({input$opioids}) 
  # output$Alts <- renderPrint({input$alts})
  # 
  # output$DrugCost <- renderText({paste("Cost Difference of Covering", input$drugCost)})
   output$dEffect <- renderPlotly({top_5_side_effects(input$drugEffect)})
}

shinyApp(ui = ui, server = server)

