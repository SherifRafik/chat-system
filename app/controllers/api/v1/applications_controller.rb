# frozen_string_literal: true

module Api
  module V1
    class ApplicationsController < ApplicationController
      before_action :set_application, only: %i[show update destroy]

      def index
        applications = Application.all
        render json: serialize(applications)
      end

      def show
        render json: serialize(application)
      end

      def create
        creator = Applications::ApplicationCreator.new(params: application_params)
        application = creator.application
        if creator.call
          render json: serialize(application), status: :created
        else
          render json: application.errors, status: :unprocessable_entity
        end
      end

      def update
        if application.update(application_params)
          render json: serialize(application)
        else
          render json: application.errors, status: :unprocessable_entity
        end
      end

      def destroy
        application.destroy
        head :no_content
      end

      private

      attr_reader :application

      def set_application
        @application = Application.find_by!(token: params[:token])
      end

      def application_params
        params.require(:application).permit(:name)
      end

      def serialize(data)
        Api::V1::ApplicationBlueprint.render(data)
      end
    end
  end
end
