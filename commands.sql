Exibir Todos os Bloqueios Ativos

SELECT * FROM performance_schema.data_locks

Identificar Transações com Bloqueios Pendentes

SELECT ENGINE_TRANSACTION_ID, OBJECT_SCHEMA, OBJECT_NAME, LOCK_TYPE, LOCK_MODE, LOCK_STATUS 
FROM performance_schema.data_locks
WHERE LOCK_STATUS = 'PENDING';

Para encontrar a thread associada a um bloqueio, use a coluna THREAD_ID e relacione com performance_schema.threads

SELECT dl.THREAD_ID, dl.OBJECT_SCHEMA, dl.OBJECT_NAME, dl.LOCK_TYPE, dl.LOCK_STATUS, t.PROCESSLIST_ID, t.PROCESSLIST_INFO 
FROM performance_schema.data_locks dl
JOIN performance_schema.threads t ON dl.THREAD_ID = t.THREAD_ID;

Relacionar Bloqueios com Transações
Para correlacionar os bloqueios com as transações ativas, use o ENGINE_TRANSACTION_ID com INFORMATION_SCHEMA.INNODB_TRX:

SELECT trx.trx_id, trx.trx_mysql_thread_id, trx.trx_query, dl.OBJECT_SCHEMA, dl.OBJECT_NAME, dl.LOCK_TYPE, dl.LOCK_STATUS 
FROM information_schema.innodb_trx trx
JOIN performance_schema.data_locks dl ON trx.trx_id = dl.ENGINE_TRANSACTION_ID;

Encerrar Threads Bloqueadoras Se necessário, use o comando KILL para encerrar uma thread problemática:

KILL <thread_id>;

SELECT THREAD_ID, PROCESSLIST_ID, PROCESSLIST_USER, PROCESSLIST_HOST, PROCESSLIST_DB, PROCESSLIST_INFO 
FROM performance_schema.threads;

As transações que não executaram COMMIT podem estar mantendo bloqueios. Para identificar essas transações, podemos consultar a tabela INNODB_TRX do information_schema e a tabela data_locks do performance_schema.
SELECT trx.trx_id, trx.trx_mysql_thread_id, trx.trx_query, trx.trx_state, trx.trx_started
FROM information_schema.innodb_trx trx
WHERE trx.trx_state = 'RUNNING';

SELECT dl.ENGINE_TRANSACTION_ID, dl.OBJECT_NAME, dl.LOCK_STATUS, dl.LOCK_TYPE, dl.LOCK_MODE
FROM performance_schema.data_locks dl
WHERE dl.ENGINE_TRANSACTION_ID = <trx_id>;


SELECT dl.THREAD_ID, dl.OBJECT_SCHEMA, dl.OBJECT_NAME, dl.LOCK_TYPE, dl.LOCK_STATUS, t.PROCESSLIST_ID, t.PROCESSLIST_INFO 
FROM performance_schema.data_locks dl
JOIN performance_schema.threads t ON dl.THREAD_ID = t.THREAD_ID;

