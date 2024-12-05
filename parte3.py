import psycopg2
import sys
import pytest


class ExcepcionPuerto(Exception):
    pass

def conexiónConParámetros():
    "Le pide al usuario unos parámetros que debe completar para conectarse a la base de datos."

    try:
        puerto = int(input("Inserte el número de puerto: "))
        if puerto < 1024 or puerto > 65535:
            raise ValueError
        else:
            return puerto
    except ValueError:
        raise ExcepcionPuerto  
    #finally:
    #    return puerto        


def peticiónConParámetros():
    "Pide los parámetros de conexión."
    host = 'localhost'
    puerto = conexiónConParámetros()
    usuario = 'apruebapeletres'
    contraseña = 'contraseña'
    base_de_datos = 'pl3'
    return (host, puerto, usuario, contraseña, base_de_datos)

def main():
    try: 
        (host, puerto, usuario, contraseña, base_de_datos) = peticiónConParámetros()
        connstring = f'host={host} port={puerto} user={usuario} password={contraseña} dbname={base_de_datos}'
        conn = psycopg2.connect(connstring)

        cur = conn.cursor()
        query = 'SELECT Título_Disco FROM disco'
        cur.execute(query)
        for record in cur.fetchall():
            print(record)
        cur.close
        conn.close
        

    except ExcepcionPuerto:
        print("El puerto no es válido.")
        print("El usuario interrumpió el programa.")
    finally:
        print("Programa finalizado.")

if __name__ == '__main__':
    main()
