install:
	mix deps.get
	npm install
	mix compile
	mix ecto.create

start:
	mix phoenix.server

test:
	mix test
