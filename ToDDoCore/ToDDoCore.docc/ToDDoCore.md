# ``ToDDoCore``

Creating core domain for future TO-Do List project

## Overview

<!--@START_MENU_TOKEN@-->Text<!--@END_MENU_TOKEN@-->

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->


## Requirement

- Retrieve
    - Empty Data
    - Non-empty Database returns data
    - Non-empty Database returns twice the same data (No side-effects)
    - Error (If applicable, e.g. invalid data)

- Insert
    - To empty Database store data insert data
    - To non-empty Database with matched data update data with new one
    - To non-empty Database with no matched data insert data to database
    - Error (If applicable, e.g. no write permission, not enough storage)

- Delete
    - Empty Database does nothing
    - To non-empty Database with matched data remove selected data
    - To non-empty Database with no matched data does nothing
    - Error (If applicable, e.g. no delete permission)

## Model

- Data Model
    - ˋidˋ : UUID
    - ˋcategoryˋ : String
    - ˋexpectedDateˋ : Date
    - ˋfinishedDateˋ : Date?
    - ˋpriorityˋ : Int
    - ˋtitleˋ : String
    - ˋisDoneˋ : Bool
    - ˋurlˋ : URL?
    - ˋnoteˋ : String?
    - ˋtagˋ : String?
    - ˋimageDataˋ : Data? 
    - ˋsubTasksˋ : SubTasks 

- SubTasks
    - ˋidˋ : UUID
    - ˋisDoneˋ : Bool
    - ˋtitleˋ :  String
