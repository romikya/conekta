# Biblioteca Conekta

Biblioteca de Elixir para comunicarse con el API de Conekta (<https://api.conekta.io>)

## Donde empezar

### Instalación

Agrega la biblioteca al archivo `mix.exs` como una dependencia más:

```elixir
#mix.exs
defp deps do
  [
    {:conekta, github: romikya/conekta}
  ]
end
```

## Configuración

Agrega las llaves a tu archivo `config/config.exs`

```elixir
# config/config.exs
config :conekta,
  public_key: "YOUR-PUBLIC-KEY",
  private_key: "YOUR-PRIVATE-KEY"
```

Para facilitar la asignación de las variables de entorno en la maquina local, se recomienda el uso de [direnv](https://direnv.net/).

### Configurar el entorno

Copiar archivo .env.dev como .envrc

```console
cp .env.dev .envrc
```

Verificar que el archivo tiene las variables asignadas:

```console
$ cat .envrc
export CKTA_PUBLIC_KEY="PUBLIC-KEY-VALUE"
export CKTA_PRIVATE_KEY="PRIVATE-KEY-VALUE"
```

Dar permiso para leer el archivo a direnv:

```console
$ direnv allow .envrc
direnv: loading ~/conekta/.envrc
direnv: export +CKTA_PRIVATE_KEY +CKTA_PUBLIC_KEY -PS2
```

Recuerda que en tu proyecto debes leer las variables de entorno en tu archivo de configuración:

```elixir
# config/config.exs
config :conekta,
  public_key: System.get_env("CKTA_PUBLIC_KEY"),
  private_key: System.get_env("CKTA_PRIVATE_KEY")
```

Si estás usando Phoenix, lo recomendable sería que lo pusieras en el archivo `config/runtime.exs`

```elixir
# config/runtime.exs
config :conekta,
  public_key: System.get_env("CKTA_PUBLIC_KEY"),
  private_key: System.get_env("CKTA_PRIVATE_KEY")
```

## Clientes (Customers)

### Obtener Clientes

Obtener los clientes actuales

```elixir
  Conekta.Customers.customers()
```

### Crear un cliente

Crear un cliente a partir de una estructura `%Conekta.Customer{}`

```elixir
new_customer = %Customer{
  name: "Fake Name",
  email: "fake@email.com",
  corporate: true,
  payment_sources: [%{
      token_id: "tok_test_visa_4242",
      type: "card"
  }]
}

Conekta.Customers.create(new_customer)

```

### Encontrar un cliente

Encontrar un cliente pasando el identificador

```elixir
Conekta.Customers.find(id)
```

### Borrar un cliente

Borrar un cliente pasando el identificador

```elixir
Conekta.Customers.delete(id)
```

## Pedidos (Orders)

### Obtener pedidos

```elixir
Conekta.Orders.orders()
```

### Crear un pedido

```elixir
new_order = %Order{currency: "MXN",
customer_info: %{
    customer_id: content.id
}, line_items: [%{
    name: "Product 1",
    unit_price: 35000,
    quantity: 1
}], charges: [%{
    payment_method: %{
        type: "default"
    }
}]}

response = Conekta.Orders.create(new_order)
```

## Enlaces de pagos

### Crear un enlace

```elixir
iex> Conekta.Checkouts.create_payment_link(%PaymentLink{
  name: "a payment link",
  type: "PaymentLink",
  expires_at: 1637714928,
  recurrent: false,
  allowed_payment_methods: ["cash", "card", "bank_transfer"],
  monthly_installments_enabled: false,
  order_template: %{
    currency: "MXN",
    customer_info: %{
      name: "test paymentlink",
      email: "pedro+test@ventup.com.mx",
      phone: "8115898281"
    },
    line_items: [
      %{
        name: "ventup month",
        unit_price: 10000,
        quantity: 1
      }
    ]
  },
  needs_shipping_contact: false
})

iex> {:ok,
 %{
   "allowed_payment_methods" => ["card", "cash", "bank_transfer"],
   "can_not_expire" => false,
   "emails_sent" => 0,
   "exclude_card_networks" => [],
   "expires_at" => 1637714928,
   "force_3ds_flow" => false,
   "id" => "d8d629ef-4d34-4b59-bf24-17acdddb7553",
   "livemode" => false,
   "metadata" => %{},
   "monthly_installments_enabled" => false,
   "monthly_installments_options" => [],
   "name" => "a payment link",
   "needs_shipping_contact" => false,
   "object" => "checkout",
   "paid_payments_count" => 0,
   "recurrent" => false,
   "slug" => "d8d629ef4d344b59bf2417acdddb7553",
   "sms_sent" => 0,
   "starts_at" => 1637647200,
   "status" => "Issued",
   "type" => "PaymentLink",
   "url" => "https://pay.conekta.com/link/d8d629ef4d344b59bf2417acdddb7553"
 }}
```

## WebHooks

Función auxiliar para el manejo de webhooks. [Posibles eventos](https://developers.conekta.com/resources/webhooks)

```elixir
case Conekta.WebHook.received(params) do
  {:charge_created, struct} -> ...
  {:charge_paid, struct} -> ...
  {:plan_created, struct} -> ...
  {:customer_created, struct} -> ...
  {:subscription_created, struct} -> ...
  {:subscription_paid, struct} -> ...
  {:subscription_canceled, struct} -> ...
  {:chargeback_created, struct} -> ...
  {:chargeback_lost, struct} -> ...
end
```

## Pruebas Unitarias

Como siempre, las pruebas unitarias pueden ejecutarse con:

```elixir
mix test
```

## Cómo contribuir

Clona el repositorio usando git con ssh:

```
$ git clone git@github.com:romikya/conekta.git
```

## Pre-requisitos

Para construir el proyecto, se utilizan las siguientes herramientas:

### [asdf](https://asdf-vm.com/)

* Puedes ver [como funciona aquí](https://asdf-vm.com/guide/introduction.html#how-it-works).
* Y puedes ver [como instalarlo aquí](https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies)

Para instalar Erlang y Elixir deben usarse los plugins de asdf:

```shell
$ asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
$ asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
$ asdf install
```

### Enviar una solicitud de cambios (Pull Request)

Si deseas enviar algún cambio, debes basarte en la rama de `develop`, de esta forma se pueden enviar tus cambios en la siguiente liberación de una nueva versión sin perder los cambios en los que esté trabajando el equipo.

### Licencia

Desarrollada por [Jorge Chavez](https://twitter.com/JorgeChavz).
Versión basada en el fork de: [Ventup](https://github.com/Ventup-IT)
Actualizada y mantenida desde julio de 2023 por el equipo de [RomikyaLabs](https://github.com/romikya)

Disponibles con la [licencia MIT](https://github.com/echavezNS/conekta-elixir/blob/master/LICENSE).
