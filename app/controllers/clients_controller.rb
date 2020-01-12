class ClientsController < ApplicationController
    def index
        @clients = Client.all
    end

    def show
        @client = Client.find(params[:id])
    end

    def new
        @client = Client.new
    end

    def edit
        @client = Client.find(params[:id])
    end

    def create
        @client = Client.new(client_params)
        if @client.save
            flash[:notice] = 'Cliente registrado com sucesso'
            redirect_to @client
        else
            render :new
        end
    end

    def update
        @client = Client.find(params[:id])
        if @client.update(client_params)
            flash[:notice] = 'Cliente editado com sucesso'
            redirect_to @client
        else
            render :edit
        end
    end

    def destroy
        @client = Client.find(params[:id])
        if @client.destroy
            flash[:notice] = 'Cliente deletado com sucesso'
            redirect_to clients_path
        else
            # flash[:alert] = 'Ops, algo deu errado'
            # redirect_to @client
        end
    end

    private

    def client_params
        params.require(:client).permit(:name, :cpf, :email)
    end
end