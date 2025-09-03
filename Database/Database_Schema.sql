-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.alumnidetails (
  user_id bigint NOT NULL,
  batch_year integer NOT NULL,
  company text,
  designation text,
  linkedin_url text,
  verification_status boolean NOT NULL DEFAULT false,
  CONSTRAINT alumnidetails_pkey PRIMARY KEY (user_id),
  CONSTRAINT alumnidetails_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.chat_messages (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  sender_id bigint NOT NULL,
  receiver_id bigint NOT NULL,
  message text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT chat_messages_pkey PRIMARY KEY (id),
  CONSTRAINT chat_messages_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.users(id),
  CONSTRAINT chat_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id)
);
CREATE TABLE public.mentorship_bookings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  session_id bigint NOT NULL,
  student_id bigint NOT NULL,
  booking_status text NOT NULL DEFAULT 'booked'::text CHECK (booking_status = ANY (ARRAY['booked'::text, 'cancelled'::text, 'completed'::text])),
  payment_status text NOT NULL DEFAULT 'pending'::text CHECK (payment_status = ANY (ARRAY['free'::text, 'paid'::text, 'pending'::text])),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT mentorship_bookings_pkey PRIMARY KEY (id),
  CONSTRAINT mentorship_bookings_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.mentorship_sessions(id),
  CONSTRAINT mentorship_bookings_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id)
);
CREATE TABLE public.mentorship_sessions (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  alumni_id bigint NOT NULL,
  student_id bigint NOT NULL,
  topic text NOT NULL,
  date_time timestamp with time zone NOT NULL,
  duration integer NOT NULL CHECK (duration > 0),
  price numeric NOT NULL CHECK (price >= 0::numeric),
  status text NOT NULL DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'accepted'::text, 'completed'::text, 'cancelled'::text])),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT mentorship_sessions_pkey PRIMARY KEY (id),
  CONSTRAINT mentorship_sessions_alumni_id_fkey FOREIGN KEY (alumni_id) REFERENCES public.users(id),
  CONSTRAINT mentorship_sessions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id)
);
CREATE TABLE public.notifications (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id bigint NOT NULL,
  message text NOT NULL,
  type text NOT NULL CHECK (type = ANY (ARRAY['system'::text, 'referral_update'::text, 'webinar_update'::text, 'mentorship_update'::text])),
  is_read boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT notifications_pkey PRIMARY KEY (id),
  CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.referrals (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  student_id bigint NOT NULL,
  alumni_id bigint NOT NULL,
  status text NOT NULL CHECK (status = ANY (ARRAY['pending'::text, 'accepted'::text, 'rejected'::text])),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT referrals_pkey PRIMARY KEY (id),
  CONSTRAINT referrals_alumni_id_fkey FOREIGN KEY (alumni_id) REFERENCES public.users(id),
  CONSTRAINT referrals_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id)
);
CREATE TABLE public.reviews_feedback (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id bigint NOT NULL,
  target_id bigint NOT NULL,
  type text NOT NULL CHECK (type = ANY (ARRAY['webinar'::text, 'mentorship'::text, 'referral'::text])),
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT reviews_feedback_pkey PRIMARY KEY (id),
  CONSTRAINT reviews_feedback_target_id_fkey FOREIGN KEY (target_id) REFERENCES public.users(id),
  CONSTRAINT reviews_feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.studentdetails (
  user_id bigint NOT NULL,
  current_year integer NOT NULL,
  branch text NOT NULL,
  skills ARRAY,
  CONSTRAINT studentdetails_pkey PRIMARY KEY (user_id),
  CONSTRAINT studentdetails_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.transactions (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  payer_id bigint NOT NULL,
  payee_id bigint NOT NULL,
  amount numeric NOT NULL CHECK (amount > 0::numeric),
  type text NOT NULL CHECK (type = ANY (ARRAY['referral_fee'::text, 'webinar_fee'::text, 'mentorship_fee'::text, 'platform_fee'::text])),
  reference_id bigint,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT transactions_pkey PRIMARY KEY (id),
  CONSTRAINT transactions_payer_id_fkey FOREIGN KEY (payer_id) REFERENCES public.users(id),
  CONSTRAINT transactions_payee_id_fkey FOREIGN KEY (payee_id) REFERENCES public.users(id)
);
CREATE TABLE public.users (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  name text NOT NULL,
  email text NOT NULL UNIQUE,
  password_hash text NOT NULL,
  role text NOT NULL DEFAULT 'student'::text CHECK (role = ANY (ARRAY['student'::text, 'alumni'::text, 'admin'::text])),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT users_pkey PRIMARY KEY (id)
);
CREATE TABLE public.webinar_registrations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  webinar_id bigint NOT NULL,
  student_id bigint NOT NULL,
  payment_status text NOT NULL DEFAULT 'pending'::text CHECK (payment_status = ANY (ARRAY['free'::text, 'paid'::text, 'pending'::text])),
  joined_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT webinar_registrations_pkey PRIMARY KEY (id),
  CONSTRAINT webinar_registrations_webinar_id_fkey FOREIGN KEY (webinar_id) REFERENCES public.webinars(id),
  CONSTRAINT webinar_registrations_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id)
);
CREATE TABLE public.webinars (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  alumni_id bigint NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  date_time timestamp with time zone NOT NULL,
  price numeric NOT NULL CHECK (price >= 0::numeric),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT webinars_pkey PRIMARY KEY (id),
  CONSTRAINT webinars_alumni_id_fkey FOREIGN KEY (alumni_id) REFERENCES public.users(id)
);