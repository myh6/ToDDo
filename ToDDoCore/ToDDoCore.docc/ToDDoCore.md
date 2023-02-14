# ``ToDDoCore``

Creating core domain for future TO-Do List project

## Overview

<!--@START_MENU_TOKEN@-->Text<!--@END_MENU_TOKEN@-->

## List Group

### Data: FeedListGroup

### Retrieve

1. Empty database retrieve no list group
2. Non-empty database returns list group
3. Non-empty databse has no side-effects
4. Error (If applicable, e.g. invalid data)

### Delete

1. Empty database does nothing
2. To non-empty database with matched data removed selected data
3. To non-empty database with no mathced data does nothing
4. Error (If applicable, e.g. no delte permission)

### Update

1. Empty database does nothing
2. To non-empty database with matched data updata data
3. To non-empty database with no matched data does nothing
4. Error (If applicable, e.g. not enough storage)

### Insert

1. To empty database insert data
2. To non-empty database insrt data
4. Error (e.g. not enough storage)

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
