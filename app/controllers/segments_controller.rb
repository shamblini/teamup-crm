class SegmentsController < ApplicationController
  before_action :set_segment, only: [:show, :edit, :update, :destroy]

  def index
    @segments = Segment.all
  end

  def show
    @users = User.all
    puts ">>>showing segment: #{@segment.name}"
    puts ">>>segment filters: #{@segment.filters.map(&:name).join(', ')}"

    @segment.filters.each do |filter|
      if User.column_names.include?(filter.name)
        if filter.attribute_type == 'numerical'
          @users = @users.where("#{filter.name} >= ? AND #{filter.name} <= ?", filter.data[0], filter.data[1])
        else
          @users = @users.where("#{filter.name} IN (?)", filter.data)
        end
      else
        @users = @users.where(FilterHelper.send(filter.name, filter.data))
      end
    end
  end

  def new
    @segment = Segment.new
    @filters_data = fetch_filters_data
    @categorical_attributes_classes = fetch_categorical_attributes_classes
    @numerical_attributes = fetch_numerical_attributes
  end

  def edit
  end

  # def create
  #   @categorical_attributes_classes = fetch_categorical_attributes_classes
  #   @numerical_attributes = fetch_numerical_attributes
  #   puts "segment_params: #{segment_params}" 
  #   selected_filters = segment_params[:filters].reject { |filter| filter[0] == '0' }
  
  #   filters_data = selected_filters.map do |filter|
  #     name = filter[1]
  #     attribute_type = filter[2]
  
  #     if attribute_type == 'numerical'
  #       data = [segment_params[:min_values][name], segment_params[:max_values][name]].map(&:to_i)
  #     elsif attribute_type == 'categorical'
  #       data = segment_params[:class_values][name]
  #     end
  
  #     [name, attribute_type, data]
  #   end
  
  #   @segment = Segment.new(name: segment_params[:name])
  #   @segment.initialize_with_filters(filters_data)
  
  #   respond_to do |format|
  #     if @segment.save
  #       format.html { redirect_to @segment, notice: 'Segment was successfully created.' }
  #       format.json { render :show, status: :created, location: @segment }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @segment.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  
  def create
    puts ">>>segment_params: #{segment_params}"
    # filters_data = segment_params[:filters].reject { |filter| filter[0] == '0' }.map { |filter| [filter[1], filter[2], filter[3]] }
    filters_data = format_filters(segment_params)
    puts ">>>filter_data: #{filters_data}"
    @segment = Segment.new(name: segment_params[:name])
    @segment.initialize_with_filters(filters_data)
    
    # Fetch filters data again to ensure it's available for the view
    @filters_data = fetch_filters_data
    
    respond_to do |format|
      if @segment.save
        format.html { redirect_to @segment, notice: 'Segment was successfully created.' }
        format.json { render :show, status: :created, location: @segment }
      else
        format.html { render :new }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @segment.update(segment_params)
        format.html { redirect_to @segment, notice: 'Segment was successfully updated.' }
        format.json { render :show, status: :ok, location: @segment }
      else
        format.html { render :edit }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @segment.destroy
    respond_to do |format|
      format.html { redirect_to segments_url, notice: 'Segment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_segment
      @segment = Segment.find(params[:id])
    end

    def segment_params
      # params.require(:segment).permit(:name, :description, :criteria, filters: [])
      params.require(:segment).permit!
    end

    def exclusion_list
      ["id", "name", "email", "created_at", "updated_at", "donations_id", "logs_id", "campaigns_id", "group_id"]
      # campaign name should be allowed
    end

    def fetch_filters_data()
      filters_data = []
      
      User.columns.each do |column|
        if [:integer, :float, :decimal].include?(column.type) && !column.name.in?(exclusion_list)
          
          filters_data << [column.name, 'numerical', [nil, nil], 0]
        elsif [:string, :text].include?(column.type) && !column.name.in?(exclusion_list)
          attribute_values = User.pluck(column.name).compact
          classes_with_counts = attribute_values.each_with_object(Hash.new(0)) { |class_value, counts| counts[class_value] += 1 }
          sorted_classes = classes_with_counts.sort_by { |class_value, count| -count }.map(&:first)
          filters_data << [column.name, 'categorical', sorted_classes, 0]
        end
      end
    
      filters_data
    end

    def format_filters(segment_params)
      filters = segment_params[:filters][0].reject do |key, filter|
        filter['3'] == ["0"]
      end
      filters.values.each_with_index.map do |filter, index|
        name = filter['0']
        attribute_type = filter['1']
        
        if attribute_type == 'numerical'
          data = filter['2'].values.reject { |value| value == ["0"] }.flatten
          data = data.map(&:to_i)
        elsif attribute_type == 'categorical'
          data = filter['2'].values.reject { |value| value == ["0"] }.flatten
          data = data.reject { |value| value == "0" }
          data = data.map(&:to_s)
        end

        puts ">>>filter ITWORKS: #{name}, #{attribute_type}, #{data}"
        [name, attribute_type, data]
      end
    end
end
