CREATE DEFINER=`khan_suds_db`@`localhost` FUNCTION `getNextCustomSeq`(sSeqName VARCHAR(50),
    sSeqGroup VARCHAR(10)) RETURNS varchar(20) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
BEGIN
    DECLARE nLast_val INT; 
 
    SET nLast_val =  (SELECT seq_val
                          FROM _sequence
                          WHERE seq_name = sSeqName
                                AND seq_group = sSeqGroup);
    IF nLast_val IS NULL THEN
        SET nLast_val = 1;
        INSERT INTO _sequence (seq_name,seq_group,seq_val)
        VALUES (sSeqName,sSeqGroup,nLast_Val);
    ELSE
        SET nLast_val = nLast_val + 1;
        UPDATE _sequence SET seq_val = nLast_val
        WHERE seq_name = sSeqName AND seq_group = sSeqGroup;
    END IF; 
 
    SET @ret = (SELECT concat(sSeqGroup,lpad(nLast_val,6,'0')));
    RETURN @ret;
END

===================================================================================

CREATE DEFINER=`khan_suds_db`@`localhost` PROCEDURE `sp_setCustomVal`(sSeqName VARCHAR(50),  
              sSeqGroup VARCHAR(10), nVal INT UNSIGNED)
BEGIN
    IF (SELECT COUNT(*) FROM _sequence  
            WHERE seq_name = sSeqName  
                AND seq_group = sSeqGroup) = 0 THEN
        INSERT INTO _sequence (seq_name,seq_group,seq_val)
        VALUES (sSeqName,sSeqGroup,nVal);
    ELSE
        UPDATE _sequence SET seq_val = nVal
        WHERE seq_name = sSeqName AND seq_group = sSeqGroup;
    END IF;
END

========================================================================================

CREATE _sequence table