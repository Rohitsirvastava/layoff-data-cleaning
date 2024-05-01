select *
from layoffs ;

-- 1 Removing Duplicates
-- 2 Standardize the Data
-- 3 Null values or blank Values
-- 4 Rmoving Columns or rows 


-- 1 Removing Duplicates

Create Table Layoffs_staging
like layoffs ;

insert Layoffs_staging
select *
from Layoffs_staging;

select *,
row_number () over ( Partition by company, location, industry, total_laid_off,
 percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from Layoffs_staging;


With duplicates_cte as
(
select *,
row_number () over ( Partition by company, location, industry, total_laid_off,
 percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from Layoffs_staging
 )
 select *
 from duplicates_cte
 where row_num > 1;
 
 select* 
 from Layoffs_staging
 where company = 'casper';
 
 
 
 CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into layoffs_staging2
select *,
row_number () over ( Partition by company, location, industry, total_laid_off,
 percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from Layoffs_staging;


Delete 
from layoffs_staging2
 where row_num > 1;
 
 
Select *
from layoffs_staging2;


-- 2 Standardize the Data

Select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct industry
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'crypto%';

select distinct country
from layoffs_staging2
order by 1;

Select *
from layoffs_staging2
where country like 'united states%'
order by 1;

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;


update layoffs_staging2
set country =  trim(trailing '.' from country)
where country like 'united states%';

select `date`
str_to_date (`date`, '%m/%d/%Y')
from layoffs_staging2;
 
 update layoffs_staging2
 set `date` = str_to_date (`date`, '%m/%d/%Y');
 
 ALTER TABLE layoffs_staging2
 MODIFY COLUMN `date` DATE;
 
 SELECT *
 FROM layoffs_staging2;
 
 
 -- 3 Null values or blank Values
 
 Select*
 from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null;
 
 
  Select distinct industry
 from layoffs_staging2;


  Select *
 from layoffs_staging2
 where industry is null
 or industry = '';
 
 select *
 from layoffs_staging2
 where company = 'airbnb';
 
 
 update	layoffs_staging2
 set industry = null
 where industry = '';
 
 
 select t1.industry, t2.industry
 from layoffs_staging2 t1
 join layoffs_staging2 t2
 on t1.company = t2.company
 and t1.location = t2.location
 where (t1.industry is null or t1.industry = '')
 and t2.industry is not null;


update layoffs_staging2 t1
join layoffs_staging2 t2
 on t1.company = t2.company
 set t1.industry = t2.industry
 where t1.industry is null 
 and t2.industry is not null; 
 
 Select*
 from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null;
 
 
 delete 
from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null; 
 
 select*
 from layoffs_staging2;
 
 
 
 alter table layoffs_staging2
 drop column row_num;