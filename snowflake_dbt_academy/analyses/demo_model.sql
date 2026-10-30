{{ codegen.generate_source(
    schema_name = 'public',
    database_name = 'raw',
    name = 'src_public',
        include_database = True,
        include_schema = True) 
}}