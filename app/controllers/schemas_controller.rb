class SchemasController < ApplicationController
  before_action :set_schema, only: [:show, :edit, :update, :destroy]

  # GET /schemas
  def index
    @schemas = Schema.all
  end

  # GET /schemas/1
  def show
  end

  # GET /schemas/new
  def new
    @schema = Schema.new
  end

  # GET /schemas/1/edit
  def edit
  end

  # POST /schemas
  def create
    @schema = Schema.new(schema_params)

    if @schema.save
      redirect_to @schema, notice: 'Schema was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /schemas/1
  def update
    if @schema.update(schema_params)
      redirect_to @schema, notice: 'Schema was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /schemas/1
  def destroy
    @schema.destroy
    redirect_to schemas_url, notice: 'Schema was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schema
      @schema = Schema.find(params[:uuid])
    end

    # Only allow a trusted parameter "white list" through.
    def schema_params
      params.require(:schema).permit(:name, :container, :description, :displayField, :fields, :segmentField, :urlFields)
    end
end
