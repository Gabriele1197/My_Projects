/*Project Explanation:

- In the first phase, the necessary join operations were performed to obtain a dataset containing 
  the information required for the analysis: first, the table containing customer data was joined 
  with the table containing account data for those customers. A left join was used to preserve 
  information for customers without a bank account;

  subsequently, a join was performed between the transactions table and the table containing 
  transaction types. Again, a left join was used to preserve the transactions for which 
  the transaction type might accidentally not have been recorded, as the operation was performed 
  on the "id_tipo_transazione" column. This choice was made because one of the requested outputs 
  was to calculate the total amount of incoming and outgoing transactions, regardless of the 
  type of account held.

  Eventually, the resulting join between the customers and accounts table and the transactions and 
  transaction type table was further joined using a left join on the "id_conto" column;

- From the final union, the fields "id_cliente", "nome" and "cognome" were included;

- All subsequent fields were calculated:

  .age was calculated by subtracting the birth year of customers from the current year;

  .counts were performed using "CASE WHEN" statements, which would return 1 as the result 
   whenever the condition was met, after which each returned result would be counted;

  .for accounts held by type and transaction amounts divided by type, the "DISTINCT" keyword 
   was used to count the values separately when the specified condition occurred;

  .sums were also performed using "CASE WHEN" statements, which would return 1 as the result 
   if the condition was met and "NULL" otherwise. All obtained results were then summed;

  .eventually, the "GROUP BY" function was used to group the results obtained based on the dataset dimensions.

*/

select

cli.id_cliente,

cli.nome,

cli.cognome, 

year(current_date())-year(data_nascita) as età,

count(case when transazioni.segno= "-" then 1 else null end) as transazioni_uscita,

count(case when transazioni.segno= "+" then 1 else null end) as transazioni_entrata,

sum(case when transazioni.segno= "-" then round(abs(transazioni.importo), 2) else 0 end) as totale_transato_uscita,

sum(case when transazioni.segno= "+" then round(transazioni.importo, 2) else 0 end) as totale_transato_entrata,

count(distinct con.id_conto) as numero_conti_posseduti,

count(distinct con.id_tipo_conto) as tipi_di_conti_posseduti,

count(distinct case when con.id_tipo_conto= "0" then 1 else null end) as conto_base,

count(distinct case when con.id_tipo_conto= "1" then 1 else null end) as conto_business,

count(distinct case when con.id_tipo_conto= "2" then 1 else null end) as conto_privati,

count(distinct case when con.id_tipo_conto= "3" then 1 else null end) as conto_famiglie,

count(case when transazioni.segno="-" and con.id_tipo_conto="0" then 1 else null end) as conto_base_uscita,

count(case when transazioni.segno="-" and con.id_tipo_conto="1" then 1 else null end) as conto_business_uscita,

count(case when transazioni.segno="-" and con.id_tipo_conto="2" then 1 else null end) as conto_privati_uscita,

count(case when transazioni.segno="-" and con.id_tipo_conto="3" then 1 else null end) as conto_business_uscita,

count(case when transazioni.segno="+" and con.id_tipo_conto="0" then 1 else null end) as conto_base_entrata,

count(case when transazioni.segno="+" and con.id_tipo_conto="1" then 1 else null end) as conto_business_entrata,

count(case when transazioni.segno="+" and con.id_tipo_conto="2" then 1 else null end) as conto_privati_entrata,

count(case when transazioni.segno="+" and con.id_tipo_conto="3" then 1 else null end) as conto_business_entrata,

sum(case when transazioni.segno="-" and con.id_tipo_conto="0" then round(abs(transazioni.importo), 2) else 0 end) as conto_base_uscita,

sum(case when transazioni.segno="-" and con.id_tipo_conto="1" then round(abs(transazioni.importo), 2) else 0 end) as conto_business_uscita,

sum(case when transazioni.segno="-" and con.id_tipo_conto="2" then round(abs(transazioni.importo), 2) else 0 end) as conto_privati_uscita,

sum(case when transazioni.segno="-" and con.id_tipo_conto="3" then round(abs(transazioni.importo), 2) else 0 end) as conto_business_uscita,

sum(case when transazioni.segno="+" and con.id_tipo_conto="0" then round(transazioni.importo, 2) else 0 end) as conto_base_entrata,

sum(case when transazioni.segno="+" and con.id_tipo_conto="1" then round(transazioni.importo, 2) else 0 end) as conto_business_entrata,

sum(case when transazioni.segno="+" and con.id_tipo_conto="2" then round(transazioni.importo, 2) else 0 end) as conto_privati_entrata,

sum(case when transazioni.segno="+" and con.id_tipo_conto="3" then round(transazioni.importo, 2) else 0 end) as conto_business_entrata

from banca.cliente cli

left join banca.conto con 

on cli.id_cliente=con.id_cliente 

left join (

select *

from banca.transazioni trans 

left join banca.tipo_transazione t_trans 

on trans.id_tipo_trans=t_trans.id_tipo_transazione) transazioni

on con.id_conto=transazioni.id_conto

group by 1,2,3,4




