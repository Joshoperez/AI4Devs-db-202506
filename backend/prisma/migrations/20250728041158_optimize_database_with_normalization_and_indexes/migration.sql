/*
  Warnings:

  - You are about to drop the column `status` on the `application` table. All the data in the column will be lost.
  - You are about to drop the column `result` on the `interview` table. All the data in the column will be lost.
  - You are about to drop the column `employment_type` on the `position` table. All the data in the column will be lost.
  - You are about to drop the column `location` on the `position` table. All the data in the column will be lost.
  - You are about to drop the column `status` on the `position` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[candidate_id,position_id]` on the table `application` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name]` on the table `interview_flow` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name]` on the table `interview_type` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `application_status_id` to the `application` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `application` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `candidate` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `company` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `education` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `employee` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `interview` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `interview_flow` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `interview_flow` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `interview_step` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `interview_type` table without a default value. This is not possible if the table is not empty.
  - Added the required column `position_status_id` to the `position` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `position` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `resume` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `work_experience` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "application" DROP COLUMN "status",
ADD COLUMN     "application_status_id" INTEGER NOT NULL,
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "candidate" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "company" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "is_active" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "education" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "employee" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "interview" DROP COLUMN "result",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "interview_result_id" INTEGER,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "interview_flow" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "is_active" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "name" VARCHAR(255) NOT NULL,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "interview_step" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "is_active" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "interview_type" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "is_active" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "position" DROP COLUMN "employment_type",
DROP COLUMN "location",
DROP COLUMN "status",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "employment_type_id" INTEGER,
ADD COLUMN     "location_id" INTEGER,
ADD COLUMN     "position_status_id" INTEGER NOT NULL,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "resume" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "work_experience" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- CreateTable
CREATE TABLE "employment_type" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "description" VARCHAR(200),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "employment_type_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "location" (
    "id" SERIAL NOT NULL,
    "city" VARCHAR(100) NOT NULL,
    "state" VARCHAR(100),
    "country" VARCHAR(100) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "location_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "application_status" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "description" VARCHAR(200),
    "color" VARCHAR(7),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "application_status_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "interview_result" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "description" VARCHAR(200),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "interview_result_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "position_status" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "description" VARCHAR(200),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "position_status_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "employment_type_name_key" ON "employment_type"("name");

-- CreateIndex
CREATE UNIQUE INDEX "location_city_state_country_key" ON "location"("city", "state", "country");

-- CreateIndex
CREATE UNIQUE INDEX "application_status_name_key" ON "application_status"("name");

-- CreateIndex
CREATE UNIQUE INDEX "interview_result_name_key" ON "interview_result"("name");

-- CreateIndex
CREATE UNIQUE INDEX "position_status_name_key" ON "position_status"("name");

-- CreateIndex
CREATE UNIQUE INDEX "application_candidate_id_position_id_key" ON "application"("candidate_id", "position_id");

-- CreateIndex
CREATE UNIQUE INDEX "interview_flow_name_key" ON "interview_flow"("name");

-- CreateIndex
CREATE UNIQUE INDEX "interview_type_name_key" ON "interview_type"("name");

-- AddForeignKey
ALTER TABLE "position" ADD CONSTRAINT "position_position_status_id_fkey" FOREIGN KEY ("position_status_id") REFERENCES "position_status"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "position" ADD CONSTRAINT "position_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "location"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "position" ADD CONSTRAINT "position_employment_type_id_fkey" FOREIGN KEY ("employment_type_id") REFERENCES "employment_type"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "application" ADD CONSTRAINT "application_application_status_id_fkey" FOREIGN KEY ("application_status_id") REFERENCES "application_status"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "interview" ADD CONSTRAINT "interview_interview_result_id_fkey" FOREIGN KEY ("interview_result_id") REFERENCES "interview_result"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
