--Remove Constraints...
DECLARE  @ConstraintName	SYSNAME
		 ,@TableName		SYSNAME = 'DimProduct'
         ,@SQL				NVARCHAR(4000);

DECLARE ConstraintsCursor CURSOR FOR
	SELECT	name
	FROM	sys.objects
	WHERE	[type] = 'D'
			AND OBJECT_NAME(parent_object_id) = @TableName;

OPEN ConstraintsCursor;

FETCH NEXT FROM ConstraintsCursor INTO @ConstraintName;

WHILE (@@FETCH_STATUS = 0)
BEGIN
    
	SELECT	@SQL = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT ' + @ConstraintName
    
	EXEC sp_executesql @SQL;

	FETCH NEXT FROM ConstraintsCursor INTO @ConstraintName;
END

CLOSE ConstraintsCursor;
DEALLOCATE ConstraintsCursor;
