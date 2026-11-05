-- Copyright 2026 Circle Internet Group, Inc.  All rights reserved.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- SPDX-License-Identifier: Apache-2.0

-- transaction_history had no row-level security, so anyone with the public
-- Supabase key could read every user's history and write rows for any user.
-- The app only reads and inserts the signed-in user's own rows, so that's all
-- these policies allow. Updates and deletes stay blocked.

ALTER TABLE public.transaction_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow authenticated users to read their own transactions"
ON public.transaction_history
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Allow authenticated users to insert their own transactions"
ON public.transaction_history
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);
