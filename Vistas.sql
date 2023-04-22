--northwind 1
--Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, and a column called "Shipped" that displays "On Time" if the order shipped on time and "Late" if the order shipped late.
--Order by employee last_name, then by first_name, and then descending by number of orders.
--Mostrar el nombre y apellido del empleado, una columna "num_orders" con la cantidad de pedidos realizados, y una columna llamada "Shipped" que muestra "On Time" si el pedido se envió a tiempo y "Late" si se envió tarde.
--Ordenar por apellido del empleado, luego por nombre, y luego en orden descendente por número de pedidos.

CREATE VIEW employee_order_info AS
SELECT
  e.first_name,
  e.last_name,
  COUNT(o.order_id) As num_orders,
  (
    CASE
      WHEN o.shipped_date < o.required_date THEN 'On Time'
      ELSE 'Late'
    END
  ) AS shipped
FROM orders o
  JOIN employees e ON e.employee_id = o.employee_id
GROUP BY
  e.first_name,
  e.last_name,
  shipped
ORDER BY
  e.last_name,
  e.first_name,
  num_orders DESC

--Hospital 1.
--Show all of the patients grouped into weight groups.
--Show the total amount of patients in each weight group.
--Order the list by the weight group decending.
--For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

SELECT
  COUNT(*) AS patients_in_group,
  FLOOR(weight / 10) * 10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;


--Hospital 2.
--Show patient_id, weight, height, isObese from the patients table.
--Display isObese as a boolean 0 or 1.
--Obese is defined as weight(kg)/(height(m)2) >= 30.
--weight is in units kg.
--height is in units cm.

SELECT patient_id, weight, height, 
  (CASE 
      WHEN weight/(POWER(height/100.0,2)) >= 30 THEN
          1
      ELSE
          0
      END) AS isObese
FROM patients;

--hospital 3
--Show patient_id, first_name, last_name, and attending doctor's specialty.
--Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'
--Check patients, admissions, and doctors tables for required information.

SELECT
  p.patient_id,
  p.first_name AS patient_first_name,
  p.last_name AS patient_last_name,
  ph.specialty AS attending_doctor_specialty
FROM patients p
  JOIN admissions a ON a.patient_id = p.patient_id
  JOIN doctors ph ON ph.doctor_id = a.attending_doctor_id
WHERE
  ph.first_name = 'Lisa' and
  a.diagnosis = 'Epilepsy'


--hospital 4
--All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
--The password must be the following, in order:
--1. patient_id
--2. the numerical length of patient's last_name
--3. year of patient's birth_date

SELECT
  DISTINCT P.patient_id,
  CONCAT(
    P.patient_id,
    LEN(last_name),
    YEAR(birth_date)
  ) AS temp_password
FROM patients P
  JOIN admissions A ON A.patient_id = P.patient_id

--hospital 5
--Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.
--Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.

SELECT 
CASE WHEN patient_id % 2 = 0 Then 
    'Yes'
ELSE 
    'No' 
END as has_insurance,
SUM(CASE WHEN patient_id % 2 = 0 Then 
    10
ELSE 
    50 
END) as cost_after_insurance
FROM admissions 
GROUP BY has_insurance;

--hospital 6
--Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name

SELECT pr.province_name
FROM patients AS pa
  JOIN province_names AS pr ON pa.province_id = pr.province_id
GROUP BY pr.province_name
HAVING
  COUNT( CASE WHEN gender = 'M' THEN 1 END) > COUNT( CASE WHEN gender = 'F' THEN 1 END);

--hospital 7
--We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- First_name contains an 'r' after the first two letters.
-- Identifies their gender as 'F'
-- Born in February, May, or December
-- Their weight would be between 60kg and 80kg
-- Their patient_id is an odd number
-- They are from the city 'Kingston'

SELECT *
FROM patients
WHERE
  first_name LIKE '__r%'
  AND gender = 'F'
  AND MONTH(birth_date) IN (2, 5, 12)
  AND weight BETWEEN 60 AND 80
  AND patient_id % 2 = 1
  AND city = 'Kingston';

--Hospital 8
--Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.
SELECT CONCAT(
    ROUND(
      (
        SELECT COUNT(*)
        FROM patients
        WHERE gender = 'M'
      ) / CAST(COUNT(*) as float),
      4
    ) * 100,
    '%'
  ) as percent_of_male_patients
FROM patients;