from sqlalchemy_schemadisplay import create_schema_graph
from sqlalchemy import MetaData
from database import Base
from database import engine

graph = create_schema_graph(
    engine=engine,
    metadata=Base.metadata,
    show_datatypes=True,   # mostra tipos de dados (Integer, String...)
    show_indexes=False,    # mostra índices
    rankdir='LR',          # orientação do grafo
    concentrate=False      # evita colapsar linhas
)

graph.write_png('er_diagram.png')  # salva em imagem
graph.write_png('er_diagram.dot')