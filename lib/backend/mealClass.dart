enum MealType{                                                                  // the 4 main meals to track
  breakfast,
  lunch,
  dinner,
  snack
}

class Meal{
  MealType mealType;                                                            // sets its type from the enum
  bool state;                                                                   // whether it has been selected in the UI. Used to determine which image to show (colored = true and black/white = false)

  Meal(this.mealType, this.state);                                              // constructor to initialize the object


  String toString(){                                                            // override to return a String of the enum type to make it more readable to the user
    switch(mealType) {
      case MealType.breakfast: {
          return "Breakfast";
        }
        break;
      case MealType.lunch: {
        return "Lunch";
      }
      break;
      case MealType.dinner: {
        return "Dinner";
      }
      break;
      case MealType.snack: {
        return "Snack";
      }
      break;
      default:
        {
          return "unknown";
        }
        break;
    }
  }

}