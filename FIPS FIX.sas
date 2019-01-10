/*********************************************************************************************************/
/* This is a macro to fix the problems of FIPS codes from some data sources that do not have all 5 digits
this macro program can easily be adjusted to fit with different cases of the problems you may encounter 
with minor adjustments. This mainly focused for governmental data sets that tend to create a variable for 
FIPS County and a seperate variable for FIPS STATE but do not leave leading zeros or store them as numbers*/
/
/* Author: Robert F. Schuldt *********** Email:RSchuldt@uams.edu 1/2019 ***********************************/


/* Observe the final line of the program to see where you will enter in your dataset and variables */
%macro fips(set, state, count);

data fips_fix; /*Chose whatever name you please*/
	set &set;
	drop single;

/*For No Leading Zero States*/
	length state_code $ 2;
	state_code = "  ";
		/* State FIPS with both digits*/

	if &state ge 10 then state_code = &state;
/**IF YOU ARE NOT USING THE TWO DIGIT STATE DELETE THE ABOVE LINE AND SUBSTITUTE THE FOLLOWING:
	state_code = &state;
***************************************************************************************/
	length single $ 2;
	single = "  ";
		if &state lt 10 then single = &state;
		if state_code = '' then state_code = put(input(single, best2.),z2.);
		single ="";
/*********************************end of fix for FIPS STATE CODE*********************/

/* Fix the FIPS county code with two and one digit***********************************/
	length county_code $ 3;
	county_code = '';

	/*because we are using the leading zeros we can just combine the two in one
	fell swoop rather then break up into different data steps*/
	if &count ge 100 then county_code = &count;
	if &count lt 10 then single = &count;

	if &count ge 10 and &count lt 100 then single = &count;

	if county_code = '' then county_code = put(input(single, best3.),z3.);

			length fips $ 5;
			fips = cats(state_code,county_code);

run;

%mend fips;

%fips( /*First Insert Data Set Here*/ , /*Enter variable name for FIPS STATE*/ , /* Eneter name here for FIPS_CNTY_CD*/)
