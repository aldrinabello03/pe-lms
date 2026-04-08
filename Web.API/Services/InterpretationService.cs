namespace Web.API.Services;

public static class InterpretationService
{
    public static string ComputeBmiClassification(double bmi)
    {
        if (bmi < 18.5) return "UNDERWEIGHT";
        if (bmi >= 18.5 && bmi <= 24.9) return "NORMAL";
        if (bmi >= 25 && bmi <= 29.9) return "OVERWEIGHT";
        return "OBESE";
    }

    public static string ComputeBalance(int? balanceLeft, int? balanceRight, int age)
    {
        if (balanceLeft == null || balanceRight == null) return string.Empty;
        var average = (balanceLeft.Value + balanceRight.Value) / 2;

        if (age >= 9 && age <= 12)
        {
            if (average >= 41 && average <= 60) return "Excellent";
            if (average >= 31 && average <= 40) return "Very Good";
            if (average >= 21 && average <= 30) return "Good";
            if (average >= 11 && average <= 20) return "Fair";
            if (average >= 1 && average <= 10) return "Needs Improvement";
        }
        else if (age >= 13 && age <= 14)
        {
            if (average >= 81 && average <= 100) return "Excellent";
            if (average >= 61 && average <= 80) return "Very Good";
            if (average >= 41 && average <= 60) return "Good";
            if (average >= 21 && average <= 40) return "Fair";
            if (average >= 1 && average <= 20) return "Needs Improvement";
        }
        else if (age >= 15 && age <= 16)
        {
            if (average >= 121 && average <= 150) return "Excellent";
            if (average >= 91 && average <= 120) return "Very Good";
            if (average >= 61 && average <= 90) return "Good";
            if (average >= 31 && average <= 60) return "Fair";
            if (average >= 1 && average <= 30) return "Needs Improvement";
        }
        else if (age >= 17)
        {
            if (average >= 161 && average <= 180) return "Excellent";
            if (average >= 121 && average <= 160) return "Very Good";
            if (average >= 81 && average <= 120) return "Good";
            if (average >= 41 && average <= 80) return "Fair";
            if (average >= 1 && average <= 40) return "Needs Improvement";
        }
        return string.Empty;
    }

    public static string ComputeJuggling(int? hits)
    {
        if (hits == null) return string.Empty;
        if (hits >= 41) return "Excellent";
        if (hits >= 31 && hits <= 40) return "Very Good";
        if (hits >= 21 && hits <= 30) return "Good";
        if (hits >= 11 && hits <= 20) return "Fair";
        if (hits >= 1 && hits <= 10) return "Needs Improvement";
        return string.Empty;
    }

    public static string ComputeZipper(double? gap)
    {
        if (gap == null) return string.Empty;
        var g = gap.Value;
        if (g >= 6) return "Excellent";
        if (g >= 4 && g <= 5.9) return "Very Good";
        if (g >= 2 && g <= 3.9) return "Good";
        if (g >= 0.1 && g <= 1.9) return "Fair";
        if (g == 0) return "Needs Improvement";
        return "Poor";
    }

    public static string ComputeSitAndReach(double? first, double? second)
    {
        if (first == null || second == null) return string.Empty;
        var highest = first >= second ? first.Value : second.Value;
        if (highest >= 61) return "Excellent";
        if (highest >= 46 && highest <= 60.9) return "Very Good";
        if (highest >= 31 && highest <= 45.9) return "Good";
        if (highest >= 16 && highest <= 30.9) return "Fair";
        if (highest >= 0 && highest <= 15.9) return "Needs Improvement";
        return string.Empty;
    }

    public static string ComputeLongJump(int? first, int? second)
    {
        if (first == null || second == null) return string.Empty;
        var highest = first >= second ? first.Value : second.Value;
        if (highest >= 201) return "Excellent";
        if (highest >= 151 && highest <= 200) return "Very Good";
        if (highest >= 126 && highest <= 150) return "Good";
        if (highest >= 101 && highest <= 125) return "Fair";
        if (highest >= 55 && highest <= 100) return "Needs Improvement";
        return string.Empty;
    }

    public static string ComputeStickDrop(double? d1, double? d2, double? d3)
    {
        if (d1 == null || d2 == null || d3 == null) return string.Empty;
        // Median of three values: sort and take the middle
        double[] vals = [d1.Value, d2.Value, d3.Value];
        Array.Sort(vals);
        double middle = vals[1];

        if (middle >= 0 && middle <= 2.4) return "Excellent";
        if (middle >= 5.08 && middle <= 10.16) return "Very Good";
        if (middle >= 12.70 && middle <= 17.78) return "Good";
        if (middle >= 20.32 && middle <= 25.40) return "Fair";
        if (middle >= 27.94 && middle <= 30.48) return "Needs Improvement";
        return "Poor";
    }

    public static string ComputePushUp(int? pushUps, string? gender)
    {
        if (pushUps == null) return string.Empty;
        if (pushUps >= 33) return "Excellent";
        if (pushUps >= 25 && pushUps <= 32) return "Very Good";
        if (pushUps >= 17 && pushUps <= 24) return "Good";
        if (pushUps >= 9 && pushUps <= 16) return "Fair";
        if (pushUps >= 1 && pushUps <= 8) return "Needs Improvement";
        return "Poor";
    }

    public static string ComputePlank(int? time)
    {
        if (time == null) return string.Empty;
        if (time >= 51) return "Excellent";
        if (time >= 46 && time <= 50) return "Very Good";
        if (time >= 31 && time <= 45) return "Good";
        if (time >= 16 && time <= 30) return "Fair";
        if (time >= 1 && time <= 15) return "Needs Improvement";
        return string.Empty;
    }

    public static string ComputeSprint(double? sprintTime, string? gender, int age)
    {
        if (sprintTime == null) return string.Empty;
        var t = sprintTime.Value;
        bool isMale = string.Equals(gender, "male", StringComparison.OrdinalIgnoreCase);

        if (isMale)
        {
            if (age >= 9 && age <= 12)
            {
                if (t < 6) return "Excellent";
                if (t >= 6.1 && t <= 7.7) return "Very Good";
                if (t >= 7.8 && t <= 8.5) return "Good";
                if (t >= 8.6 && t <= 9.5) return "Fair";
                if (t >= 9.6) return "Needs Improvement";
            }
            else if (age >= 13 && age <= 14)
            {
                if (t < 5) return "Excellent";
                if (t >= 5.1 && t <= 6.9) return "Very Good";
                if (t >= 7 && t <= 8) return "Good";
                if (t >= 8.1 && t <= 9.1) return "Fair";
                if (t >= 9.2) return "Needs Improvement";
            }
            else if (age >= 15 && age <= 16)
            {
                if (t < 4.5) return "Excellent";
                if (t >= 4.6 && t <= 5.4) return "Very Good";
                if (t >= 5.5 && t <= 7) return "Good";
                if (t >= 7.1 && t <= 8.1) return "Fair";
                if (t >= 8.2) return "Needs Improvement";
            }
            else if (age >= 17)
            {
                if (t < 4) return "Excellent";
                if (t >= 4.1 && t <= 5.4) return "Very Good";
                if (t >= 5.5 && t <= 6.5) return "Good";
                if (t >= 6.6 && t <= 7.5) return "Fair";
                if (t >= 7.6) return "Needs Improvement";
            }
        }
        else
        {
            if (age >= 9 && age <= 12)
            {
                if (t < 7) return "Excellent";
                if (t >= 7.1 && t <= 8.4) return "Very Good";
                if (t >= 8.5 && t <= 9.5) return "Good";
                if (t >= 9.6 && t <= 10.5) return "Fair";
                if (t >= 10.6) return "Needs Improvement";
            }
            else if (age >= 13 && age <= 14)
            {
                if (t < 6.5) return "Excellent";
                if (t >= 6.6 && t <= 7.6) return "Very Good";
                if (t >= 7.7 && t <= 8.8) return "Good";
                if (t >= 8.9 && t <= 9.5) return "Fair";
                if (t >= 9.6) return "Needs Improvement";
            }
            else if (age >= 15 && age <= 16)
            {
                if (t < 5.5) return "Excellent";
                if (t >= 5.6 && t <= 6.1) return "Very Good";
                if (t >= 6.2 && t <= 7.2) return "Good";
                if (t >= 7.3 && t <= 8.5) return "Fair";
                if (t >= 8.6) return "Needs Improvement";
            }
            else if (age >= 17)
            {
                if (t < 4.5) return "Excellent";
                if (t >= 4.6 && t <= 5.9) return "Very Good";
                if (t >= 6 && t <= 7) return "Good";
                if (t >= 7.1 && t <= 8.1) return "Fair";
                if (t >= 8.2) return "Needs Improvement";
            }
        }
        return string.Empty;
    }
}
