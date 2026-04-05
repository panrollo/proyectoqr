# Demo seed de Formacion

## Orden de ejecucion

1. `python backend/scripts/rebuild_demo_database.py`
2. `python backend/scripts/finalize_demo_setup.py`
3. `python backend/scripts/validate_demo_setup.py`

## Credenciales demo

| Rol | Correo | Contrasena |
|---|---|---|
| admin | `admin@local.test` | `Admin12345!` |
| formador | `formador1@local.test` | `Formador12345!` |
| formador | `formador2@local.test` | `Formador12345!` |
| lider | `lider@local.test` | `Lider12345!` |
| jefe_fc | `jefe.fc@local.test` | `JefeFC12345!` |
| analista | `analista@local.test` | `Analista12345!` |
| supervisor | `supervisor@local.test` | `Supervisor12345!` |
| jefe_ops | `jefe.ops@local.test` | `JefeOps12345!` |
| agente | `agente@local.test` | `Agente12345!` |

## Uso sugerido por modulo

- `admin@local.test`: bootstrap, catalogos y gestion global.
- `formador1@local.test`: flujo de asistencia para la sesion `7101`.
- `formador2@local.test`: flujo de asistencia para la sesion `7102`.
- `lider@local.test`, `jefe.fc@local.test`, `analista@local.test`, `supervisor@local.test`, `jefe.ops@local.test`, `agente@local.test`: validacion de login y navegacion por rol.

## Validaciones sugeridas

- `GET /health`
- `POST /api/auth/login`
- `GET /api/bootstrap` con token `Bearer`
- `GET /api/trainer/attendance/sessions` con usuario `formador`
- `GET /api/trainer/attendance/sessions/{virtual_session_id}/qr`
- `GET /api/public/qr/{qr_token}`
