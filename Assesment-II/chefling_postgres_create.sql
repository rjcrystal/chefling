-- Stores user information 
CREATE TABLE "users" (
	"id" serial NOT NULL,
	"name" character varying(255) NOT NULL,
	"email" character varying(255) NOT NULL,
	"in_group" bool NOT NULL DEFAULT 'false',
	"created_at" TIMESTAMP NOT NULL,
	"updated_at" TIMESTAMP NOT NULL,
	CONSTRAINT users_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);


-- Stores shopping list items with user_id
CREATE TABLE "shopping_list_items" (
	"id" serial NOT NULL,
	"name" varchar(255) NOT NULL,
	"user_id" int NOT NULL,
	"quantity" int,
	"note" TEXT,
	"category_id" int NOT NULL,
	CONSTRAINT shopping_list_items_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);


-- Stores category details
CREATE TABLE "category" (
	"id" serial NOT NULL,
	"name" varchar(255) NOT NULL UNIQUE,
	"description" TEXT NOT NULL,
	CONSTRAINT category_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);


-- Stores group details 
CREATE TABLE "group" (
	"id" serial NOT NULL,
	"group_name" varchar(255) NOT NULL,
	"created_by" int NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"updated_at" TIMESTAMP,
	CONSTRAINT group_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);


-- Stores changes related to shopping list by user
CREATE TABLE "shopping_list_changelog" (
	"id" serial NOT NULL,
	"user_id" int NOT NULL,
	"old_payload" json NOT NULL,
	"new_payload" json NOT NULL,
	"changed_item_id" int NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	CONSTRAINT shopping_list_changelog_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);


-- Stores user and group association so a group can have multiple users
CREATE TABLE "user_group" (
	"user_id" int NOT NULL,
	"group_id" int NOT NULL
) WITH (
  OIDS=FALSE
);


-- Stores group invite details where a user can accept or reject group invite
CREATE TABLE "group_invite" (
	"id" serial NOT NULL,
	"invitee_id" int NOT NULL,
	"invited_by" int NOT NULL,
	"status" bool NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"updated_at" TIMESTAMP,
	CONSTRAINT group_invite_pk PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



-- Constraints
ALTER TABLE "shopping_list_items" ADD CONSTRAINT "shopping_list_items_fk0" FOREIGN KEY ("user_id") REFERENCES "users"("id");
ALTER TABLE "shopping_list_items" ADD CONSTRAINT "shopping_list_items_fk1" FOREIGN KEY ("category_id") REFERENCES "category"("id");


ALTER TABLE "group" ADD CONSTRAINT "group_fk0" FOREIGN KEY ("created_by") REFERENCES "users"("id");

ALTER TABLE "shopping_list_changelog" ADD CONSTRAINT "shopping_list_changelog_fk0" FOREIGN KEY ("user_id") REFERENCES "users"("id");
ALTER TABLE "shopping_list_changelog" ADD CONSTRAINT "shopping_list_changelog_fk1" FOREIGN KEY ("changed_item_id") REFERENCES "shopping_list_items"("id");

ALTER TABLE "user_group" ADD CONSTRAINT "user_group_fk0" FOREIGN KEY ("user_id") REFERENCES "users"("id");
ALTER TABLE "user_group" ADD CONSTRAINT "user_group_fk1" FOREIGN KEY ("group_id") REFERENCES "group"("id");

ALTER TABLE "group_invite" ADD CONSTRAINT "group_invite_fk0" FOREIGN KEY ("invitee_id") REFERENCES "users"("id");
ALTER TABLE "group_invite" ADD CONSTRAINT "group_invite_fk1" FOREIGN KEY ("invited_by") REFERENCES "users"("id");


-- Query to fetch shopping list items when user is in a group
SELECT * FROM shopping_list_items 
join user_group ug on ug.user_id = 1 --user id provided by application 
join user_group ug2 on ug2.group_id = ug.group_id 
where shopping_list_items.user_id in (ug2.user_id)


