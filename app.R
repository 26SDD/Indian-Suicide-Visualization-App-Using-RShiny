#####################PACKAGES#######################
ifelse(!require(shiny), install.packages('shiny'), library(shiny))
ifelse(!require(ggthemes), install.packages('ggthemes'), library(ggthemes))
ifelse(!require(devtools), install.packages('devtools'), library(devtools))
ifelse(!require(ggplot2), devtools::install_github('hadley/ggplot2'), library(ggplot2))
ifelse(!require(dplyr), install.packages('dplyr'), library(dplyr))
ifelse(!require(tidyr), install.packages('tidyr'), library(tidyr))
ifelse(!require(data.table), install.packages('data.table'), library(data.table))
ifelse(!require(shinythemes), install.packages('shinythemes'), library(shinythemes))
ifelse(!require(shinydashboard), install.packages('shinydashboard'), library(shinydashboard))
ifelse(!require(shinydashboardPlus), install.packages('shinydashboardPlus'), library(shinydashboardPlus))
ifelse(!require(plotly), install.packages('plotly'), library(plotly))
ifelse(!require(plotrix),install.packages('plotrix'),library(plotrix))

#############LOAD DATA###############
if (!exists('suicide')) {
  suicide = fread(input = 'data/Suicides in India 2001-2012.csv', header = T)
} else{
  print("already exists")
}

#####################FUNCTIONS#######################
x = c('Total (All India)', 'Total (Uts)', 'Total (States)')
state_choices = suicide$State[!(suicide$State %in% x)]

#SINK ALL OUTPUT VALUES FROM THE CONSOLE TO TEXT FILE
sink('type.txt')
table(suicide$Type)
sink()

sink('causes.txt')
table(suicide$Type_code)
sink()

sink('year.txt')
table(suicide$Year)
sink()

sink('agegroup.txt')
table(suicide$Age_group)
sink()

sink('state.txt')
table(suicide$State)
sink()


###########################UI##############################
ui = dashboardPagePlus(
  header = dashboardHeaderPlus(enable_rightsidebar = TRUE,
                               rightSidebarIcon = "gears"),#header

  sidebar = dashboardSidebar(collapsed = T,
                             width = 15
                             ),#leftsidebar

  body = dashboardBody(
    tabItems(

      #`Diverging` Tab Item
      tabItem(
        tabName = 'divtab',
        fluidRow(
          column(
            width = 12,
            gradientBox(
              title = "My gradient Box",
              icon = "fa fa-th",
              boxToolSize = "sm",
              width = 12,
              plotOutput('divplot'),
              p(
                label = 'Diverging Bars for all of the States',
                width = 12
              )#textip
            )#grad-diverging
          )
        )#divFluidRow
      ),#divTab
      #Barplot Tab Item
      tabItem(
        tabName = 'bartab',
        fluidRow(
          #For Barplot
          box(
            title = 'Barplot',
            status = 'warning',
            width = 12,
            #for placing hist
            fluidRow(
              column(
                width = 12,
                boxPad(
                  color = 'grey',
                  gradientBox(
                    title = "Suicide Barplot",
                    icon = "fa fa-th",
                    gradientColor = "teal",
                    width = 12,
                    #Input in footer
                    footer = column(
                      width = 12,
                      align = "center",
                      #Selecting States
                      selectInput(
                        inputId = 'bp_state',
                        choices = unique(state_choices),
                        selected = character(0),
                        label = 'States',
                        multiple = T
                      ),#selectinput-stateip
                      #Select Year
                      selectInput(
                        inputId = 'bp_year',
                        choices = unique(suicide$Year),
                        selected = 1,
                        label = 'Year'
                      ), #select bp year
                      #Radio Button Age-Group
                      radioButtons(
                        inputId = 'bp_age',
                        label = 'Age Group',
                        choices = unique(suicide$Age_group),
                        inline = T
                      )#rbtn-age
                    ),#footer column
                    plotlyOutput("barplot")
                  )#barGardientBody
                )#boxpad
              )#column
            )#internal-fuildrow
          )#box-barplot
        )#BarplotFluidRow
      ),#barplotTab
      #Pie Chart Item
      tabItem(
        tabName = 'pietab',
        h1('Pie Menu'),
        fluidRow(
          #fluid Row for pie inputs
          fluidRow(
            #state
            column(
              width = 6,
              #Selecting States
              selectInput(
                inputId = 'pie_state',
                choices = unique(state_choices),
                selected = 1,
                label = 'States'
              )#selectinput-stateip
            ), #col-pie-select-state
            #Year
            column(width = 6,
                   #Select Year
                   selectInput(
                     inputId = 'pie_year',
                     choices = unique(suicide$Year),
                     selected = 1,
                     label = 'Year'
                   )#select pie year
            )#col-pie-select-year
          ), #Input-Fluid

          column(
            width = 6,
            boxPad(
              color = 'black',
              plotlyOutput('piechartMale')
            )#boxpad-male
          ),#col-male
          column(
            width = 6,
            boxPad(
              color = 'black',
              plotlyOutput('piechartFemale')
            )#boxpad-female
          )#col-female
        )#row-piechart
      ),#pieTab
      #Map Tab
      tabItem(
        tabName = 'maptab',
        h1('Map Menu'),
        box(
          title = "Box with right pad",
          status = "warning",
          fluidRow(
            column(width = 6),
            column(
              width = 6,
              boxPad(
                descriptionBlock(
                  header = "8390",
                  text = "Total Suicidal Cases",
                  right_border = FALSE,
                  margin_bottom = TRUE
                ),
                descriptionBlock(
                  header = "45%",
                  text = "Cases in male",
                  right_border = FALSE,
                  margin_bottom = TRUE
                ),
                descriptionBlock(
                  header = "55%",
                  text = "Cases in female",
                  right_border = FALSE,
                  margin_bottom = FALSE
                )
              )
            )
          )
        )
      ),#mapTab
      #User Tab
      tabItem(
        tabName = 'usertab',
        h1('User Menu'),
        fluidRow(
          column(
            width = 12,
            widgetUserBox(
              title = "Sushen Deshpande",
              subtitle = "Aspiring Data Scientist",
              type = NULL,
              src = "Sushen.jpg",
              color = "aqua-active",
              closable = TRUE,
              "To be noted",
              footer = "To be noted"
            ),
            widgetUserBox(
              title = "Akshay Shende",
              subtitle = "Aspiring Data Scientist",
              type = NULL,
              src = "",
              color = "aqua-active",
              closable = TRUE,
              "Some text here!",
              footer = "!"
            ),
            widgetUserBox(
              title = "Arnab Sarkar",
              subtitle = "Aspiring Data Scientist",
              type = NULL,
              src = "",
              color = "aqua-active",
              closable = TRUE,
              "Some text here!",
              footer = "The footer here!"
            )
          )
        )#divFluidRow
      )#userTab

    )#All tab Items
  ),#body

  rightsidebar = rightSidebar(
    background = 'dark',
    sidebarMenu(
      menuItem(
        text = "Diverging Bar",
        tabName = "divtab",
        icon = icon("gears")
      ),
      #histmenu
      menuItem("Barplot",
               tabName = "bartab",
               icon = icon("bar-chart-o")),
      #barmenu
      menuItem("PieChart",
               tabName = "pietab",
               icon = icon("cubes")),
      #piemenu
      menuItem("Map",
               tabName = "maptab",
               icon = icon("plus-circle")),
      #mapmenu
      menuItem(
        'About US',
        tabName = 'usertab',
        icon = icon("plus-circle")
      )#usermenu
    )#menuItem
  )#rightSideBar
)#ui-dashbardpage

# print(ui)

server = function(input, output) {
  require(plotly)
  data = suicide

  ######################BARPLOT#######################
  #reactive barplot
  bpdata <- reactive({
    require(dplyr)
    bpstate <- input$bp_state
    bpyear <- input$bp_year
    bpage <- input$bp_age

    test = data %>% filter(State %in% bpstate &
                             Year == bpyear &
                             Age_group == bpage & Total > 0) %>% select('State', 'Total')
    test
  })
  #bpdata for ploting
  output$barplot <- renderPlotly({
    bp <- as.data.frame(bpdata()) %>% ggplot(aes(x = State, y = Total)) + geom_bar(stat = "identity")


  })#renderplot

  #######################PIE CHART##########################
  #reactive Piechart
  pcdata_M  <- reactive({
    require(dplyr)
    piestate <- input$pie_state
    pieyear <- input$pie_year
    test1 = data %>% filter(State == piestate &
                              Year == pieyear &
                              Total > 0 &
                              Gender == 'Male') %>% select('State', 'Total', 'Type_code')
    group = test1 %>% group_by(Type_code)
    summary = group %>% summarise(Percent = n() / nrow(.) * 100)
    as.data.frame(summary)
  })
  #Reactive Female
  pcdata_F <- reactive({
    require(dplyr)
    piestate <- input$pie_state
    pieyear <- input$pie_year

    test1 = data %>% filter(State == piestate &
                              Year == pieyear &
                              Total > 0 &
                              Gender == 'Female') %>% select('State', 'Total','Type_code')
    group = test1 %>% group_by(Type_code)
    summary = group %>% summarise(Percent = n() / nrow(.) * 100)
    as.data.frame(summary)
  })#piedata for ploting

  #PIECHART PLOTING-MALE
  output$piechartMale <- renderPlotly({
    d = as.data.frame(pcdata_M())

    lbl = c("General Causes", "Education" , "Self" , "Professional", "Social")
    pie <-
      d %>% plot_ly(
        labels = ~ lbl,
        values = ~ Percent,
        type = 'pie',
        textposition = "inside",
        textinfo = 'label+percent'
      ) %>% layout(title = 'MALE')#ploty_ly male
    pie
  })#renderplot

  #PIECHART PLOTING-FEMALE
  output$piechartFemale <- renderPlotly({
    d = as.data.frame(pcdata_F())
    print(d)
    lbl = list("General Causes", "Education" , "Self" , "Professional", "Social")
    d %>% plot_ly(
      labels = ~ lbl,
      values = ~ Percent,
      type = 'pie',
      textposition = "inside",
      textinfo = 'label+percent'
    ) %>% layout(title = 'FEMALE')#ploty_ly Female
  })#renderplot

  #################DIVERGING PLOT#########################
  output$divplot <- renderPlot({
    df <- data %>% select(State, Total)
    df$normalize_occurence <- round((df$Total - mean(df$Total)) / sd(df$Total), 2)
    df$category <- ifelse(df$normalize_occurence > 0, "high", "low")
    ggplot(df, aes(x = State, y = normalize_occurence)) +
      geom_bar(aes(fill = category), stat = "identity") +
      labs(title = "Total States Suicides") +
      coord_flip()
  })#div-plot
}#server
shinyApp(ui, server)#ShinyApp

p(
  This is suicidal data
)

